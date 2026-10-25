# Extra binary caches shared by every host in this flake.
# cache.nixos.org stays the default; these are appended via extra-* settings.
# Keys are the cache operators' published Ed25519 public keys:
#   nix-community  -> https://cachix.org/api/v1/cache/nix-community
#   nixpkgs-unfree -> https://cachix.org/api/v1/cache/nixpkgs-unfree
{ ... }:
{
  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
    ];
  };
}
