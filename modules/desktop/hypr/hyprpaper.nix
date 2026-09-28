let
  laptopMonitor = "eDP-1";
  homeMonitor = "DP-2";
  workMonitor = "DP-1";
  dellMonitor = "HDMI-A-2";
  wallpaperPrimary = ../wallpapers/new-zealand-01.jpg;
  wallpaperHome = ../wallpapers/tokyo-01.jpg;
  wallpaperWork = ../wallpapers/cypress-01.jpg;
  wallpaperDell = ../wallpapers/tokyo-02.jpg;
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
