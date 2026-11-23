# Personal workstation overlay: neutral workstation + personal AI, mail, and
# editors. Airgapped: never import from profiles/personal/ on a work host.
{ ... }:
{
  imports = [
    ../workstation.nix
    ./ai.nix

    ../../antigravity.nix
    ../../gmailctl.nix
    ../../zed.nix
  ];
}
