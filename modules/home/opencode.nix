{ lib, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.opencode;
    settings = {
      # Workhorse: default coding model.
      model = "openrouter/deepseek/deepseek-v4.1-flash-1017";
      # Small/title model: cheapest 2026 pick from the small-model scan
      # (5x cheaper output than deepseek-v4-flash).
      small_model = "openrouter/nex-agi/nex-n2.5-mini";
      permission.bash = {
        sudo = "deny";
        "sudo *" = lib.hm.dag.entryAfter [ "sudo" ] "deny";
        "gmailctl apply" = lib.hm.dag.entryAfter [ "sudo *" ] "deny";
        "gmailctl apply *" = lib.hm.dag.entryAfter [ "gmailctl apply" ] "deny";
      };
    };
    tui = {
      theme = "system";
      keybinds = {
        leader = "ctrl+w";
        session_child_cycle = "<leader>e";
        session_child_cycle_reverse = "<leader>q";
      };
    };
    agents = ./opencode/agents;
    context = ./agents/AGENTS.md;
  };

  home.sessionVariables = {
    OPENCODE_ENABLE_EXA = 1;
  };
}
