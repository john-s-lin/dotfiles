{ ... }:
{
  home.file.".agents/AGENTS.md".source = ./agents/AGENTS.md;
  home.file.".codex/AGENTS.md".source = ./agents/AGENTS.md;

  home.file.".agents/skills/deep-teacher" = {
    source = ./agents/skills/deep-teacher;
    recursive = true;
  };

  xdg.configFile."opencode/AGENTS.md".source = ./agents/AGENTS.md;
}
