{ ... }:
{
  imports = [
    ../../modules/home/bat.nix
    ../../modules/home/bottom.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git.nix
    ../../modules/home/jujutsu.nix

    ../../modules/home/starship.nix
    ../../modules/home/zellij.nix
    ../../modules/home/zoxide.nix

    ../../modules/home/agents.nix
    ../../modules/home/bash.nix
    ../../modules/home/ghostty.nix
    ../../modules/home/gmailctl.nix
    ../../modules/home/helix.nix
    ../../modules/home/opencode.nix
    ../../modules/home/zed.nix
    ../../modules/home/zsh.nix

    ../../modules/packages/terminal.nix
    ../../modules/packages/workstation.nix
  ];

  home.shellAliases = {
    lg = "lazygit";
    ldock = "lazydocker";
    cat = "bat";
  };
}
