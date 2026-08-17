{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };

  xdg.configFile = {
    "waybar/config" = {
      source = ./waybar/config.json;
      onChange = ''
        ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
      '';
    };
    "waybar/style.css" = {
      source = ./waybar/style.css;
      onChange = ''
        ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
      '';
    };
  };
}
