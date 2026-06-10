{ pkgs, ... }:
{
  home.packages = with pkgs; [
    codex
    # Codex uses bwrap for Linux sandboxed command execution.
    bubblewrap
    opencode
  ];
}
