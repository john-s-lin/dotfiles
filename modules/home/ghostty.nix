{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  validate = lib.optionalString isLinux "${lib.getExe pkgs.ghostty} +validate-config --config-file=${config.xdg.configHome}/ghostty/config.ghostty";
in
{
  xdg.configFile = {
    "ghostty/config.ghostty" = {
      source = if isDarwin then ./ghostty/darwin.ghostty else ./ghostty/linux.ghostty;
      onChange = validate;
    };
    "ghostty/common.ghostty" = {
      source = ./ghostty/common.ghostty;
      onChange = validate;
    };
    "ghostty/themes" = {
      source = ./ghostty/themes;
      recursive = true;
      onChange = validate;
    };
  }
  // lib.optionalAttrs isLinux {
    "systemd/user/app-com.mitchellh.ghostty.service.d/overrides.conf".text = lib.mkForce ''
      [Unit]
      X-SwitchMethod=keep-old
      X-Reload-Triggers=${
        toString [
          config.xdg.configFile."ghostty/config.ghostty".source
          config.xdg.configFile."ghostty/common.ghostty".source
          config.xdg.configFile."ghostty/themes".source
        ]
      }
    '';
  };

  programs = {
    ghostty = {
      enable = true;
      package = if isDarwin then null else pkgs.ghostty;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };
}
