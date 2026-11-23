{ config, lib, ... }:
{
  imports = [
    ../../modules/home/profiles/base.nix

    # Neutral leaves a work machine may use: no personal accounts or endpoints.
    ../../modules/home/bash.nix
    ../../modules/home/ghostty.nix
    ../../modules/home/herdr.nix
    ../../modules/home/jujutsu.nix
    ../../modules/home/shpool.nix
    ../../modules/home/starship.nix
    ../../modules/home/zellij.nix

    ../../modules/packages/workstation.nix
  ];

  shpool.work.enable = true;

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
    "/etc/profiles/per-user/${config.home.username}/bin"
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      # This is to forward the hardware key
      forwardAgent = true;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 15;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "auto";
      controlPath = "~/.ssh/master-%C";
      controlPersist = "4h";
    };
  };

  programs.zsh.initContent = ''
    # Workaround for corp-managed /etc/zshrc wiping Nix daemon source
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
    fi
  '';

  # Intentionally newer than the personal hosts, which default to 25.05. Do not
  # align without reading the Home Manager release notes.
  home.stateVersion = "26.05";
}
