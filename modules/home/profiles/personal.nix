# Personal workstation: full desktop/terminal tooling plus the personal
# accounts and AI/cloud configuration. Never import this on a work host.
{ pkgs, ... }:
{
  imports = [
    ./base.nix

    ../agents.nix
    ../antigravity.nix
    ../bash.nix
    ../ghostty.nix
    ../gmailctl.nix
    ../herdr.nix
    ../jujutsu.nix
    ../opencode.nix
    ../pi.nix
    ../shpool.nix
    ../starship.nix
    ../zed.nix
    ../zellij.nix

    ../../packages/workstation.nix
  ];

  home.packages = [ pkgs.gh ];
}
