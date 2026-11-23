{ pkgs, username, ... }:
{
  imports = [
    ../../modules/fonts.nix
    ../../modules/packages/default.nix
    ../../modules/darwin/defaults.nix
    ../../modules/darwin/packages/common.nix
    ../../modules/gc/darwin.nix
  ];

  # Determinate Nix manages the daemon; see docs/runbooks/nix-darwin-fresh-install.md (Phase P9)
  # before toggling `nix.enable = false` (which also requires removing modules/gc/darwin.nix).

  environment.shells = [ pkgs.zsh ];

  programs.bash.enable = false;
  programs.zsh.enable = false;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  system.primaryUser = username;
  system.stateVersion = 6;
}
