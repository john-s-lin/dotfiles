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

    # Additional config
    ../../modules/home/bash.nix
    ../../modules/home/ghostty.nix
    ../../modules/home/gmailctl.nix
    ../../modules/home/helix.nix
    ../../modules/home/opencode.nix
    ../../modules/home/zed.nix
    ../../modules/home/zsh.nix

    # Terminal packages
    ../../modules/packages/gmailctl.nix
    ../../modules/packages/terminal.nix
    ../../modules/packages/workstation.nix
  ];

  home.shellAliases = {
    lg = "lazygit";
    ldock = "lazydocker";
    cat = "bat";
  };

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # Set your Home Manager state version.
  home.stateVersion = "25.05"; # Or your current version
}
