{ username, ... }:
{
  imports = [
    ../../modules/fonts.nix

    ../../modules/packages/default.nix
    ../../modules/packages/localsend.nix

    ../../modules/darwin/defaults.nix

    ../../modules/darwin/packages/ai.nix
    ../../modules/darwin/packages/common.nix
    ../../modules/darwin/packages/personal.nix
    ../../modules/darwin/packages/rclone.nix
    ../../modules/darwin/packages/work.nix

    ../../modules/darwin/services/tailscale.nix

    ../../modules/gc/darwin.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.primaryUser = username;
}
