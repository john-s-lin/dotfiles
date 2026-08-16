{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    google-chrome
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight
  ];
}
