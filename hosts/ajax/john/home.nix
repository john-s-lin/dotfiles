{ ... }:
{
  imports = [
    ../../../modules/home/profiles/server.nix
    ../../../modules/home/jujutsu.nix

    # AI/development configuration
    ../../../modules/home/agents.nix
    ../../../modules/home/opencode.nix
    ../../../modules/home/pi.nix
  ];
}