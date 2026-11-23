# Neutral server profile: safe for both personal and work servers (including
# nimbus). Leaves shpool.personal.enable off so IT-managed hosts keep their
# own shpool binary while sharing the config and prompt.
{ ... }:
{
  imports = [
    ./base.nix

    ../server.nix
    ../shpool.nix
  ];
}
