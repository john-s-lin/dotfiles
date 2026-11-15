{ pkgs, ... }:
{
  home.packages = [ pkgs.antigravity-cli ];

  home.file.".gemini/config/AGENTS.md".source = ./agents/AGENTS.md;
  home.file.".gemini/config/skills".source = ./agents/skills;
}
