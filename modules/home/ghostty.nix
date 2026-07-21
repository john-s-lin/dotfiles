{ lib, pkgs, ... }:
{
  xdg.configFile."ghostty/themes" = {
    source = ./ghostty/themes;
    recursive = true;
  };

  programs = {
    ghostty = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      settings = {
        theme = "tokyo-passion.ghostty";
        auto-update = "off";
        cursor-style = "block";
        shell-integration-features = "no-cursor,ssh-terminfo,ssh-env";
        background-opacity = 1.0;
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;
        font-thicken = false;
        window-padding-x = 5;
        window-padding-y = 5;
        quit-after-last-window-closed = true;
        confirm-close-surface = false;
        clipboard-read = "allow";
        clipboard-write = "allow";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        macos-titlebar-style = "hidden";
        font-family = "JetBrainsMono NFM Regular";
        font-family-bold = "JetBrainsMono NFM Bold";
        font-family-italic = "JetBrainsMono NFM Light Italic";
        font-family-bold-italic = "JetBrainsMono NFM Bold Italic";
        font-size = 13;
        font-thicken = true;
      };
    };
  };
}
