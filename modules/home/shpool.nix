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
in
{
  # Installs the shpool package. The config below (sshp, config.toml) is
  # neutral and applies to every host that imports this module, including nimbus,
  # where shpool itself is IT-managed and must not be installed from here.
  options.shpool = {
    personal.enable = lib.mkEnableOption "the shpool package on personal hosts";
    work.enable = lib.mkEnableOption "the shprw roadwarrior helper on work hosts";
  };

  config = lib.mkMerge [
    {
      programs.bash.initExtra = lib.mkAfter sshpFunc;
      programs.zsh.initContent = lib.mkAfter sshpFunc;
      xdg.configFile."shpool/config.toml".text = ''
        prompt_prefix = ""
      '';
    }
    (lib.mkIf config.shpool.personal.enable {
      home.packages = [ pkgs.shpool ];
    })
    (lib.mkIf config.shpool.work.enable {
      programs.bash.initExtra = lib.mkAfter shprwFunc;
      programs.zsh.initContent = lib.mkAfter shprwFunc;
    })
  ];
}
