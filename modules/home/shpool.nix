{
  lib,
  pkgs,
  config,
  ...
}:
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

  sshpFunc = ''
    sshp() {
      if [ $# -ne 2 ]; then
        echo "Usage: sshp <hostname> <session-name>" >&2
        return 1
      fi

      local host="$1"
      local session="$2"

      echo "🚀 Connecting to $host (shpool session: $session)..."
      ssh -t "$host" shpool attach -f "$session"
    }
  '';

  shellFuncs = shprwFunc + "\n" + sshpFunc;
in
{
  options.shpool.personal.enable = lib.mkEnableOption "shpool on personal servers";

  config = lib.mkMerge [
    {
      programs.bash.initExtra = lib.mkAfter shellFuncs;
      programs.zsh.initContent = lib.mkAfter shellFuncs;
      xdg.configFile."shpool/config.toml".text = ''
        prompt_prefix = ""
      '';
    }
    (lib.mkIf config.shpool.personal.enable {
      home.packages = [ pkgs.shpool ];
    })
  ];
}
