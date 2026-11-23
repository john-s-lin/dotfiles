# Personal AI tooling (shared by personal workstations and ajax).
# Airgapped: never import from profiles/personal/ on a work host.
{ ... }:
{
  imports = [
    ../../agents.nix
    ../../opencode.nix
    ../../pi.nix
  ];
}
