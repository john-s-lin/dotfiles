{ lib, pkgs, ... }:
let
  herwFunc = ''
    herw() {
      if [ $# -lt 1 ]; then
        echo "Usage: herw <hostname> [session-name]"
        return 1
      fi

      local host="$1"
      local session="''${2:-default}"

      if [[ "$host" != *.* ]]; then
        host="''${host}.c.googlers.com"
      fi

      echo "🚀 Connecting to $host (herdr session: $session) via roadwarrior..."
      rw -r -S --reconnect_loop --check_remaining "$host" -- herdr --session "$session"
    }
  '';
in
{
  home.packages = with pkgs; [
    herdr
  ];

  xdg.configFile."herdr/config.toml".source = ./herdr/config.toml;

  programs.bash.initExtra = lib.mkAfter herwFunc;

  programs.zsh.initContent = lib.mkOrder 200 ''
    ${herwFunc}

    if [[ -z "$HERDR_ENV" && -z "$ZELLIJ" && -z "$SSH_CONNECTION" && "$TERM" != "dumb" ]]; then
      ${lib.getExe pkgs.herdr}
    fi
  '';
}
