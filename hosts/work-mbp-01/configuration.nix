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

  # Disable HTML documentation build due to build failure
  # https://github.com/nix-darwin/nix-darwin/issues/1817
  documentation.enable = false;
  system.tools.darwin-uninstaller.enable = false;

  system.primaryUser = username;
  system.stateVersion = 6;
}
