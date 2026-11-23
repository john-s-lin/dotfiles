# Personal nix-darwin overlay. Never import on a work Mac.
{ ... }:
{
  imports = [
    ./base.nix

    ../../packages/localsend.nix
    ../packages/ai.nix
    ../packages/personal.nix
    ../packages/rclone.nix
    ../services/tailscale.nix
  ];
}
