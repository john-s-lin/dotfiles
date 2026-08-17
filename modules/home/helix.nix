{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  xdg.configFile."helix/config.toml" = {
    source = ./helix/config.toml;
    onChange =
      let
        pkill = if pkgs.stdenv.hostPlatform.isDarwin then "/usr/bin/pkill" else "${pkgs.procps}/bin/pkill";
      in
      "${pkill} -USR1 -u $USER -x '(hx|\\.hx-wrapped)' || true";
  };
}
