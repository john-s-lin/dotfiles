{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development tools
    gnumake
    parallel
    vscode
  ];
}
