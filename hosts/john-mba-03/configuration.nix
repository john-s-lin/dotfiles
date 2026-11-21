{ ... }:
{
  imports = [
    ../../modules/darwin/packages/vpn.nix
    ../darwin/configuration.nix
  ];
  system.stateVersion = 6;
}
