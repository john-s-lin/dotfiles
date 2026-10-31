{ lib, ... }:
let
  # Only alias when ripgrep is actually on PATH (Home Manager, Homebrew, or system).
  grepAlias = ''
    if command -v rg >/dev/null 2>&1; then
      alias grep='rg'
    fi
  '';
in
{
  programs.bash.initExtra = lib.mkAfter grepAlias;
  programs.zsh.initContent = lib.mkAfter grepAlias;
}
