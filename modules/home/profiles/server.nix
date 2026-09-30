{ ... }:
{
  imports = [
    ../bat.nix
    ../bottom.nix
    ../direnv.nix
    ../git.nix
    ../helix.nix
    ../server.nix
    ../zoxide.nix
    ../zsh.nix

    # Terminal packages
    ../../packages/terminal.nix
  ];
}