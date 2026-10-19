{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.okular
    swayimg
    qbittorrent
    signal-desktop
    vesktop
    vlc

    # File managers
    thunar
    thunar-volman
    thunar-archive-plugin
    tumbler
    yazi

    # yazi preview helpers
    ffmpeg
    p7zip
    poppler-utils
  ];
}
