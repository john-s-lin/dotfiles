# Personal servers only (ajax, dietpi). nimbus is a work host: it imports the
# neutral modules/home/server.nix leaf directly and never this profile, because
# shpool there is IT-managed.
{ ... }:
{
  imports = [
    ./base.nix

    ../jujutsu.nix
    ../server.nix
    ../shpool.nix
  ];

  shpool.personal.enable = true;
}
