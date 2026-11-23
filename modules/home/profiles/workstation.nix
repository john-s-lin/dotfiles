# Neutral workstation profile: safe for both personal and work workstations.
# Never add personal accounts, credentials, AI tooling, or cloud remotes here.
{ ... }:
{
  imports = [
    ./base.nix

    ../bash.nix
    ../ghostty.nix
    ../herdr.nix
    ../jujutsu.nix
    ../shpool.nix
    ../starship.nix
    ../zellij.nix

    ../../packages/workstation.nix
  ];

  home.shellAliases = {
    lg = "lazygit";
    ldock = "lazydocker";
    cat = "bat";
  };
}
