{ pkgs, ... }:
let
  nixDeveloperPackages = with pkgs; [
    nil
  ];
  defaultPackages = with pkgs; [
    git
    vim
    wget
  ];
  linuxPackages = with pkgs; [
    wl-clipboard

    # GUI for fingerprint enrollment via fprintd (cosmic-utils/enroll).
    # COSMIC Settings has no fingerprint page yet; enrollment data lives in
    # /var/lib/fprintd either way, so it works for every consumer.
    enroll
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
