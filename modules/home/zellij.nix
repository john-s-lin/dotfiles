{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;

    settings = {
      theme = "tokyo-night-dark";
      pane_frames = true;
      copy_command = if pkgs.stdenv.isLinux then "wl-copy" else "pbcopy";
      show_startup_tips = false;
      scroll_buffer_size = 100000;
    };
  };
}
