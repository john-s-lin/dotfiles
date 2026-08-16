{ ... }:
{
  imports = [
    ../../modules/home/bash.nix
    ../../modules/home/bat.nix
    ../../modules/home/bottom.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git.nix
    ../../modules/home/helix.nix
    ../../modules/home/server.nix
    ../../modules/home/shpool.nix
    ../../modules/home/zoxide.nix
    ../../modules/home/zsh.nix

    # Terminal packages
    ../../modules/packages/terminal.nix
  ];

  programs.zsh.initContent = ''
    if [ -e /etc/bash_completion.d/hgd ]; then
      source /etc/bash_completion.d/hgd
    fi
    if [ -e /etc/bash_completion.d/jjd ]; then
      source /etc/bash_completion.d/jjd
    fi
  '';

  home.stateVersion = "25.05";
}
