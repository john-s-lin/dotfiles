{
  pkgs,
  lib,
  ...
}:

let
  scaled = (import ../wallpapers/scaled.nix { inherit pkgs lib; }).scaledWallpaper;
  wallpaperPrimary = scaled ../wallpapers/tiantan-01.jpg 1920 1080;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
        disable_loading_bar = true;
      };

      background = {
        monitor = "";
        path = "${wallpaperPrimary}";
        blur_passes = 2;
        blur_size = 5;
      };

      input-field = {
        monitor = "eDP-1";
        size = "300, 60";
        outline_thickness = 0;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = false;
        dots_rounding = -1;
        dots_fade_time = 10;
        outer_color = "rgba(17, 17, 17, 1)";
        inner_color = "rgba(200, 200, 200, 1)";
        font_color = "rgba(100, 100, 100, 1)";
        font_family = "JetBrains Mono Nerd Font Medium Italic";
        fade_on_empty = false;
        rounding = 20;
        check_color = "rgba(204, 136, 34, 1.0)";
        fail_color = "rgba(204, 34, 34, 1.0)";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        fail_timeout = 2000;
        fail_transition = 300;
        hide_input = false;
        placeholder_text = "Input password...";
        position = "0, -350";
        halign = "center";
        valign = "center";
      };

      label = {
        monitor = "eDP-1";
        text = "cmd[update:1000] echo \"<span>$(date +'%Y-%m-%d // %H:%M:%S')</span>\"";
        color = "rgba(200, 200, 200, 1.0)";
        font_size = 50;
        font_family = "JetBrains Mono Nerd Font Bold";
        position = "0, -150";
        halign = "center";
        valign = "center";
      };
    };
  };
}
