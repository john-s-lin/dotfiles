{ pkgs, ... }:
{
  # Common terminal tools (previously in common.nix home.packages)
  home.packages = with pkgs; [
    fd
    fzf
    hyperfine
    just
    lazygit
    lazydocker
    nixfmt
    ripgrep
    tree
    rename
  ];
}
