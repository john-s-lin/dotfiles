{ pkgs, username, ... }:
{
  imports = [
    ../../modules/darwin/profiles/base.nix
  ];

  # patch: will work with Determinate Nix install
  # however, this will require disabling the nix.gc garbage collector
  # nix.enable = false;

  environment.shells = [ pkgs.zsh ];

  programs.bash.enable = false;
  programs.zsh.enable = false;

  users.users.${username} = {
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
}
