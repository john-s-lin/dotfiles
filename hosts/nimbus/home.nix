{ ... }:
{
  imports = [
    ../../modules/home/profiles/server.nix

    # Nimbus-specific
    ../../modules/home/bash.nix
    ../../modules/home/herdr.nix
    ../../modules/home/shpool.nix
  ];

  targets.genericLinux.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.zsh.initContent = ''
    if [ -e /etc/bash_completion.d/hgd ]; then
      source /etc/bash_completion.d/hgd
    fi
    if [ -e /etc/bash_completion.d/jjd ]; then
      source /etc/bash_completion.d/jjd
    fi

    # Unalias jjd since ohmyzsh jj diff alias clashes against workspace function
    unalias jjd 2>/dev/null
  '';
}