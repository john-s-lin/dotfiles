{ config, lib, ... }:
{
  services.mako.enable = true;

  xdg.configFile."mako/config" = {
    source = ./mako/config;
    onChange =
      let
        package = config.services.mako.package;
        makoctl = if package != null then lib.getExe' package "makoctl" else "makoctl";
      in
      "${makoctl} reload || true";
  };
}
