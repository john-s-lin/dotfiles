{ username, ... }:
{
  imports = [
    # Server tools (previously in server.nix)
    ../../../modules/home/bat.nix
    ../../../modules/home/bottom.nix
    ../../../modules/home/direnv.nix
    ../../../modules/home/git.nix
    ../../../modules/home/helix.nix
    ../../../modules/home/jujutsu.nix
    ../../../modules/home/server.nix
    ../../../modules/home/zsh.nix

    # AI/development packages
    ../../../modules/packages/ai.nix
    ../../../modules/home/agents.nix
    ../../../modules/home/opencode.nix

    # Terminal packages
    ../../../modules/packages/terminal.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
}
