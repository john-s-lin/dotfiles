# hosts/atlas/configuration.nix
# Target NixOS configuration for atlas, validated in CI ahead of the planned
# on-site SD card swap. Do not deploy remotely to DietPi atlas.
{ ... }:
{
  imports = [
    ../../modules/services/tailscale.nix
    ../../modules/services/cockpit.nix
  ];
}
