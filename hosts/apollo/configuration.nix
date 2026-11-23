# hosts/apollo/configuration.nix
{ ... }:
{
  imports = [
    ../../modules/services/tailscale.nix
    ../../modules/services/cockpit.nix
  ];
}
