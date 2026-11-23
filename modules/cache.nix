# Shared Nix settings for every host in this flake (NixOS, nix-darwin, and
# standalone home-manager all evaluate this module independently).
# cache.nixos.org stays the default; extra caches are appended via extra-*.
# Keys are the cache operators' published Ed25519 public keys:
#   nix-community  -> https://cachix.org/api/v1/cache/nix-community
#   nixpkgs-unfree -> https://cachix.org/api/v1/cache/nixpkgs-unfree
{ config, lib, ... }:
{
  options.dotfiles.nix.extraCaches.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Add the extra binary caches and their public keys. Disable on hosts
      where we are not a trusted user of the Nix daemon: the daemon ignores
      the settings and warns on every nix invocation.
    '';
  };

  config.nix.settings = lib.mkMerge [
    {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    }
    (lib.mkIf config.dotfiles.nix.extraCaches.enable {
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
        "https://noctalia.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    })
  ];
}
