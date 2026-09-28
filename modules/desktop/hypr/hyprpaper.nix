{
  pkgs,
  lib,
  ...
}:
let
  laptopMonitor = "eDP-1";
  homeMonitor = "DP-2";
  workMonitor = "DP-1";
  dellMonitor = "HDMI-A-2";
  scaled = (import ../wallpapers/scaled.nix { inherit pkgs lib; }).scaledWallpaper;
  # Pre-scaled to each monitor's exact resolution; see ../wallpapers/scaled.nix.
  wallpaperPrimary = scaled ../wallpapers/new-zealand-01.jpg 1920 1080;
  wallpaperHome = scaled ../wallpapers/tokyo-01.jpg 1920 1080;
  wallpaperWork = scaled ../wallpapers/cypress-01.jpg 2560 1440;
  wallpaperDell = scaled ../wallpapers/tokyo-02.jpg 1920 1080;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = laptopMonitor;
          path = "${wallpaperPrimary}";
        }
        {
          monitor = homeMonitor;
          path = "${wallpaperHome}";
        }
        {
          monitor = workMonitor;
          path = "${wallpaperWork}";
        }
        {
          monitor = dellMonitor;
          path = "${wallpaperDell}";
        }
      ];
    };
  };
}
