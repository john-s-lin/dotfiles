{ pkgs, ... }:
{
  programs.zed-editor.enable = pkgs.stdenv.hostPlatform.isLinux;

  xdg.configFile = {
    "zed/settings.json".source = ./zed/settings.json;
    "zed/themes/One_Dark_Pro.json".source = ./zed/themes/One_Dark_Pro.json;
  };
}
