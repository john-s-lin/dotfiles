{ ... }:
{
  imports = [
    ../../modules/home/profiles/server.nix
    ../../modules/home/jujutsu.nix
    ../../modules/home/shpool.nix
  ];

  shpool.personal.enable = true;
}
