{ pkgs, username, ... }:
{
  imports = [
    ../../modules/fonts.nix
    ../../modules/packages/default.nix
    ../../modules/darwin/defaults.nix
    ../../modules/darwin/packages/common.nix
    ../../modules/gc/darwin.nix
  ];

  # patch: will work with Determinate Nix install
  # however, this will require disabling the nix.gc garbage collector
  # nix.enable = false;

  environment.shells = [ pkgs.zsh ];

  programs.bash.enable = false;
  programs.zsh.enable = false;

  # Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  system.primaryUser = username;
  system.stateVersion = 6;
}
