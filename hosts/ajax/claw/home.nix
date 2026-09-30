{ ... }:
{
  imports = [
    ../../../modules/packages/agent.nix
    ../../../modules/home/git.nix
    ../../../modules/home/jujutsu.nix
    ../../../modules/home/direnv.nix

    # Shell
    ../../../modules/home/bash.nix
    ../../../modules/home/zoxide.nix

    # Terminal packages
    ../../../modules/packages/terminal.nix
  ];

  home.stateVersion = "25.05";

  xdg.enable = true;
  programs.home-manager.enable = true;
}
