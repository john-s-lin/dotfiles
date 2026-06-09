{ username, ... }:
{
  imports = [
    # Common terminal tools (previously in common.nix)
    ../../modules/home/bat.nix
    ../../modules/home/bottom.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git.nix
    ../../modules/home/jujutsu.nix

    # Workstation tools (previously in workstation.nix)
    ../../modules/home/starship.nix
    ../../modules/home/zellij.nix
    ../../modules/home/zoxide.nix

    # Additional packages
    ../../modules/packages/ai.nix
    ../../modules/packages/browsers.nix
    ../../modules/packages/developer.nix
    ../../modules/packages/gmailctl.nix
    ../../modules/packages/personal.nix
    ../../modules/packages/terminal.nix
    ../../modules/packages/work.nix
    ../../modules/packages/workstation.nix

    # Desktop
    ../../modules/desktop/cosmic/default.nix
    ../../modules/desktop/hypr/default.nix

    # Host-specific config
    ../../modules/home/alacritty.nix
    ../../modules/home/agents.nix
    ../../modules/home/codex.nix
    ../../modules/home/ghostty.nix
    ../../modules/home/gmailctl.nix
    ../../modules/home/helix.nix
    ../../modules/home/opencode.nix
    ../../modules/home/rclone.nix
    ../../modules/home/zed.nix
    ../../modules/home/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # This is being imported from the modules above
  # home.packages = with pkgs; [
  # ];

  # Aliases
  home.shellAliases = {
    lg = "lazygit";
    ldock = "lazydocker";
    cat = "bat";
    zed = "zeditor";
  };

  # Enable XDG
  xdg.enable = true;

  # Set Okular as default PDF viewer
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "okularApplication_pdf.desktop" ];
      "application/x-pdf" = [ "okularApplication_pdf.desktop" ];
      "application/acrobat" = [ "okularApplication_pdf.desktop" ];
      "application/vnd.pdf" = [ "okularApplication_pdf.desktop" ];
      "text/pdf" = [ "okularApplication_pdf.desktop" ];

      "text/html" = [ "zen-twilight.desktop" ];
      "application/xhtml+xml" = [ "zen-twilight.desktop" ];
      "x-scheme-handler/http" = [ "zen-twilight.desktop" ];
      "x-scheme-handler/https" = [ "zen-twilight.desktop" ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
