{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  validate = lib.optionalString isLinux "${lib.getExe pkgs.ghostty} +validate-config --config-file=${config.xdg.configHome}/ghostty/config";
in
{
  programs.ghostty = {
    enable = true;
    package = if isDarwin then null else pkgs.ghostty;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    systemd.enable = isLinux;
    settings = {
      theme = "tokyo-passion.ghostty";
      "auto-update" = "off";
      "cursor-style" = "block";
      "shell-integration-features" = "no-cursor,ssh-terminfo,ssh-env";
      "background-opacity" = 1.0;
      "window-padding-x" = 5;
      "window-padding-y" = 5;
      "quit-after-last-window-closed" = true;
      "confirm-close-surface" = false;
      "clipboard-read" = "allow";
      "clipboard-write" = "allow";
    }
    // lib.optionalAttrs isDarwin {
      "macos-titlebar-style" = "hidden";
      "font-family" = "JetBrainsMono NFM Regular";
      "font-family-bold" = "JetBrainsMono NFM Bold";
      "font-family-italic" = "JetBrainsMono NFM Light Italic";
      "font-family-bold-italic" = "JetBrainsMono NFM Bold Italic";
      "font-size" = 13;
      "font-thicken" = true;
    }
    // lib.optionalAttrs isLinux {
      "font-family" = "JetBrainsMono Nerd Font";
      "font-size" = 12;
      "font-thicken" = false;
    };
  };

  xdg.configFile = {
    "ghostty/themes" = {
      source = ./ghostty/themes;
      recursive = true;
      onChange = validate;
    };
    "systemd/user/app-com.mitchellh.ghostty.service.d/overrides.conf" = lib.mkIf isLinux {
      text = lib.mkForce ''
        [Unit]
        X-SwitchMethod=keep-old
        X-Reload-Triggers=${
          toString [
            config.xdg.configFile."ghostty/config".source
            config.xdg.configFile."ghostty/themes".source
          ]
        }
      '';
    };
  };
}
