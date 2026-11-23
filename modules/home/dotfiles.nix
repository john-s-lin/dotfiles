# Out-of-store paths (opencode.nix, pi.nix, noctalia.nix) point into the working
# tree, so they need its path. This option lives in a Home Manager module rather
# than modules/cache.nix because cache.nix is also imported into NixOS and
# nix-darwin system evaluation, where config.home does not exist.
{ config, lib, ... }:
{
  options.dotfiles.root = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/.dotfiles";
    description = ''
      Working-tree checkout of this repository. Used for writable out-of-store
      symlinks (opencode.nix, pi.nix) and uncopied wallpaper paths (noctalia.nix).
      Override if the repository is not cloned at ~/.dotfiles.
    '';
  };
}
