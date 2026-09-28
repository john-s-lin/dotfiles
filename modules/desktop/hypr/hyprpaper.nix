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
  wallpaperPrimary = scaled ../wallpapers/new-zealand-01.jpg 1920 1080;
  wallpaperHome = scaled ../wallpapers/tokyo-01.jpg 1920 1080;
  wallpaperWork = scaled ../wallpapers/cypress-01.jpg 2560 1440;
  wallpaperDell = scaled ../wallpapers/tokyo-03.jpg 1920 1080;
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
          fit_mode = "cover";
        }
        {
          monitor = homeMonitor;
          path = "${wallpaperHome}";
          fit_mode = "cover";
        }
        {
          monitor = workMonitor;
          path = "${wallpaperWork}";
          fit_mode = "cover";
        }
        {
          monitor = dellMonitor;
          path = "${wallpaperDell}";
          fit_mode = "cover";
        }
      ];
    };
  };
}
