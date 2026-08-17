{
  config,
  lib,
  pkgs,
  ...
}:
let
  hyprland = config.wayland.windowManager.hyprland;
  reloadConfig = ''
    (
      XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
      if [[ -d "/tmp/hypr" || -d "$XDG_RUNTIME_DIR/hypr" ]]; then
        for i in $(${hyprland.finalPackage}/bin/hyprctl instances -j | jq ".[].instance" -r); do
          ${hyprland.finalPackage}/bin/hyprctl -i "$i" reload config-only
        done
      fi
    )
  '';
in
{
  home.packages = with pkgs; [
    hyprshot
    brightnessctl
    playerctl
    overskride
    bluetui
    impala
    pavucontrol
    apple-cursor
    lm_sensors
    wlogout
    networkmanagerapplet
    networkmanager_dmenu
    psmisc
    libnotify # For notify-send testing
  ];

  imports = [
    ./rofi.nix
    ./waybar.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hypridle.nix
    ./mako.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraLuaFiles.desktop = {
      content = ./desktop.lua;
      autoLoad = true;
    };
  };

  xdg.configFile."hypr/desktop.lua".onChange = lib.mkIf (hyprland.finalPackage != null) reloadConfig;
}
