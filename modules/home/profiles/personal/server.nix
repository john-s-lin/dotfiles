# Personal server overlay (apollo, atlas, dietpi, ajax).
# Airgapped: never import from profiles/personal/ on a work host.
{ ... }:
{
  imports = [
    ../server.nix

    ../../jujutsu.nix
  ];

  shpool.personal.enable = true;
}
