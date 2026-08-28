{ pkgs, ... }:
let
  nixDeveloperPackages = with pkgs; [
    nil
  ];
  defaultPackages = with pkgs; [
    gh
    git
    vim
    wget
  ];
  linuxPackages = with pkgs; [
    wl-clipboard
  ];
in
{
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    defaultPackages
    ++ nixDeveloperPackages
    ++ (if pkgs.stdenv.hostPlatform.isLinux then linuxPackages else [ ]);
}
