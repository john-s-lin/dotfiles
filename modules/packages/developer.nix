{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development tools
    bun
    fnm
    gnumake
    parallel
    vscode
  ];
}
