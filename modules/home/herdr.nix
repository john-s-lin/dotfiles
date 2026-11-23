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

      echo "🚀 Ensuring credentials and waking $host..."
      rw -r --only_ensure_cloudtop_on "$host"

      echo "🚀 Connecting to $host (herdr session: $session) via herdr remote..."
      ${lib.getExe pkgs.herdr} --remote "$host" --session "$session"
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
  '';
}
