{ ... }:
{
  xdg.configFile."opencode/agent" = {
    source = ./opencode/agent;
    recursive = true;
  };

  xdg.configFile."opencode/opencode.jsonc".source = ./opencode/opencode.jsonc;
  xdg.configFile."opencode/tui.json".source = ./opencode/tui.json;

  home.sessionVariables = {
    OPENCODE_ENABLE_EXA = 1;
  };
}
