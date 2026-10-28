{ config, lib, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.opencode;
    settings = {
      # Workhorse: default coding model.
      model = "openrouter/deepseek/deepseek-v4.1-flash-1017";
      # Small/title model: cheapest 2026 pick from the small-model scan
      # (5x cheaper output than deepseek-v4-flash).
      agents.title.model = "openrouter/nex-agi/nex-n2.5-mini";
      permissions = [
        { action = "shell"; resource = "sudo"; effect = "deny"; }
        { action = "shell"; resource = "sudo *"; effect = "deny"; }
        { action = "shell"; resource = "gmailctl apply"; effect = "deny"; }
        { action = "shell"; resource = "gmailctl apply *"; effect = "deny"; }
      ];
    };
    agents = ./opencode/agents;
    context = ./agents/AGENTS.md;
  };

  # OpenCode 2 writes terminal state (theme overrides, panes, etc.) to cli.json.
  # Keep that file mutable in the dotfiles tree so app changes persist across hosts.
  xdg.configFile."opencode/cli.json".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/modules/home/opencode/cli.json";

  home.sessionVariables = {
    OPENCODE_ENABLE_EXA = 1;
  };
}
