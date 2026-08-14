{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (if stdenv.hostPlatform.isDarwin then nvtopPackages.apple else nvtopPackages.intel)
  ];
}
