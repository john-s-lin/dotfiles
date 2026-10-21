{ ... }:
{
  imports = [
    ../../modules/home/profiles/server.nix
    ../../modules/home/jujutsu.nix
    ../../modules/home/shpool.nix

    # AI/development configuration
    ../../modules/home/agents.nix
    ../../modules/home/opencode.nix
    ../../modules/home/pi.nix
  ];

  shpool.personal.enable = true;
}
