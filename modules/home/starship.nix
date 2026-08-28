{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$python$rust$zig$git_branch$git_commit$git_state$git_status$cmd_duration$character";

      cmd_duration = {
        min_time = 50;
        show_milliseconds = true;
        style = "yellow";
      };

      directory = {
        format = "[\\[$path\\]]($style) ";
        style = "cyan";
        truncate_to_repo = false;
        truncation_symbol = ".../";
      };

      git_branch = {
        format = "[\\[$branch(:$remote_branch)\\]]($style) ";
        style = "purple";
      };

      git_status.style = "bold purple";

      python = {
        format = "[\\(($version)( $virtualenv)\\)]($style) ";
        style = "green";
      };

      rust = {
        format = "[\\(($version)\\)]($style) ";
        style = "red";
      };

      zig = {
        format = "[\\(($version)\\)]($style) ";
        style = "yellow";
      };
    };
  };
}
