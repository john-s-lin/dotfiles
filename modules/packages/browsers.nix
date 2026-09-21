{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    google-chrome
    brave
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
