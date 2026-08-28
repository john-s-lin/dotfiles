{ lib, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.opencode;
    settings = {
      small_model = "openrouter/deepseek/deepseek-v4-flash";
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
