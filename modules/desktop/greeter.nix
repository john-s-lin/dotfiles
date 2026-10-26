# Default graphical login screen for NixOS hosts that have a GUI.
#
# Import this module from every GUI host's configuration.nix so the same
# login screen is used regardless of which desktop session is picked
# afterwards. Noctalia Greeter runs its own bundled wlroots compositor under
# greetd, so it replaces per-desktop display managers (for example
# cosmic-greeter) instead of running alongside them.
{ pkgs, ... }:
{
  services.displayManager.noctalia-greeter = {
    enable = true;
    cursorTheme = {
      package = pkgs.apple-cursor;
      name = "macOS-White";
    };
  };

  # The greeter's wlroots compositor needs GL drivers just like a desktop
  # session does. cosmic-greeter used to be the only module enabling this.
  hardware.graphics.enable = true;
}
