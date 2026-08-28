{ ... }:
{
  imports = [
    ../../modules/darwin/packages/vpn.nix
    ../aqua/configuration.nix
  ];
  system.stateVersion = 6;
}
