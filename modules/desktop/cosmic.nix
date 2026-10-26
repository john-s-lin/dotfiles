{ pkgs, ... }:
{
  # COSMIC desktop session. The login screen comes from
  # modules/desktop/greeter.nix (Noctalia Greeter via greetd), so the COSMIC
  # greeter is deliberately not enabled.
  services.desktopManager.cosmic.enable = true;

  # Exclude COSMIC apps that duplicate existing tools
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit # using Helix/Zed
    cosmic-term # using Ghostty
    cosmic-player # using VLC
  ];
}
