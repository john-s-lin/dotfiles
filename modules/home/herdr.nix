{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    herdr
  ];

  xdg.configFile."herdr/config.toml".source = ./herdr/config.toml;

  programs.zsh.initContent = lib.mkOrder 200 ''
    if [[ -z "$HERDR_ENV" && -z "$ZELLIJ" && -z "$SSH_CONNECTION" && "$TERM" != "dumb" ]]; then
      ${lib.getExe pkgs.herdr}
    fi
  '';
}
