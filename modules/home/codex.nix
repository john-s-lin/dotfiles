{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  toml = pkgs.formats.toml { };
  homeDir = config.home.homeDirectory;
  codexConfig = {
    projects = {
      "${homeDir}/.dotfiles" = {
        trust_level = "trusted";
      };
    }
    // lib.optionalAttrs (pkgs.stdenv.isDarwin && username == "john") {
      "${homeDir}/Documents/Code/instagratification" = {
        trust_level = "trusted";
      };
    };

    tui.model_availability_nux = {
      "gpt-5.5" = 2;
    };
  };
in
{
  home.file.".codex/config.toml".source = toml.generate "codex-config.toml" codexConfig;
}
