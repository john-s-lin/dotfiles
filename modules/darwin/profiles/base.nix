# Neutral nix-darwin base: safe for both personal and work Macs.
# Never add personal apps, cloud remotes, AI tools, or Tailscale here.
{ lib, username, ... }:
{
  imports = [
    ../../fonts.nix
    ../../packages/default.nix
    ../defaults.nix
    ../packages/common.nix
    ../../gc/darwin.nix
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.primaryUser = username;
  system.stateVersion = lib.mkDefault 6;
}
