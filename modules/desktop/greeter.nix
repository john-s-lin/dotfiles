# Default graphical login screen for NixOS hosts that have a GUI.
#
# Import this module from every GUI host's configuration.nix so the same
# login screen is used regardless of which desktop session is picked
# afterwards. Noctalia Greeter runs its own bundled wlroots compositor under
# greetd, so it replaces per-desktop display managers (for example
# cosmic-greeter) instead of running alongside them.
{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  # Binary cache for Noctalia (scoped to GUI NixOS hosts instead of modules/cache.nix).
  nix.settings = lib.mkIf config.dotfiles.nix.extraCaches.enable {
    extra-substituters = [
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  services.displayManager.noctalia-greeter = {
    enable = true;

    # Noctalia's auto_sync (enabled in modules/desktop/noctalia.nix) syncs the
    # desktop wallpaper/palette/font to the login screen. Allow this login user
    # to run that constrained sync without an administrator prompt each time.
    passwordlessSyncUsers = [ username ];

    cursorTheme = {
      package = pkgs.apple-cursor;
      name = "macOS-White";
    };
  };

  # The greeter's wlroots compositor needs GL drivers just like a desktop
  # session does. cosmic-greeter used to be the only module enabling this.
  hardware.graphics.enable = true;
}
