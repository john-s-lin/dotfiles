{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.okular
    swayimg
    qbittorrent
    signal-desktop
    vesktop
    vlc
  ];
}
