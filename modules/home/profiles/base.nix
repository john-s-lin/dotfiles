# Neutral leaf modules only: every cluster (personal workstation, personal
# server, work) may import this. Never add credentials, accounts, cloud
# remotes, agent configuration, or personal endpoints here.
{ ... }:
{
  imports = [
    ../dotfiles.nix

    ../bat.nix
    ../bottom.nix
    ../direnv.nix
    ../git.nix
    ../grep.nix
    ../helix.nix
    ../zoxide.nix
    ../zsh.nix

    ../../packages/terminal.nix
  ];
}
