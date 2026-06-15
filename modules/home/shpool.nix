{ lib, ... }:
let
  shprwFunc = ''
    shprw() {
      if [ $# -ne 2 ]; then
        echo "Usage: shprw <hostname> <session-name>"
        return 1
      fi

      local host="$1"
      local session="$2"

      if [[ "$host" != *.* ]]; then
        host="''${host}.c.googlers.com"
      fi

      echo "🚀 Connecting to $host (shpool session: $session) via roadwarrior..."
      rw -r -S --reconnect_loop --check_remaining --shpool_session "$session" "$host"
    }
  '';
in
{
  programs.bash.initExtra = lib.mkAfter shprwFunc;
  programs.zsh.initContent = lib.mkAfter shprwFunc;
  xdg.configFile."shpool/config.toml".text = ''
    prompt_prefix = ""
  '';
}
