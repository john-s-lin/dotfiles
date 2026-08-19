{
  pkgs,
  config,
  lib,
  hostKey ? null,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    profileExtra = ''
      if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "jj"
        "vi-mode"
      ];
    };

    # Conditional configuration for Darwin on aarch64
    # Ensures Nix profile paths take precedence over Homebrew
    initContent =
      if pkgs.stdenv.hostPlatform.isDarwin then
        ''
          # Enable unique path tracking to prevent duplicates
          typeset -U path

          if [[ $(uname -m) == 'arm64' ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
          fi

          # Re-prioritize Nix paths to take precedence over Homebrew
          # Zsh will keep the first occurrence and remove duplicates
          path=(
            "/etc/profiles/per-user/$USER/bin"
            "$HOME/.nix-profile/bin"
            $path
          )
        ''
      else
        ''
          # Enable unique path tracking to prevent duplicates
          typeset -U path

          path=(
            "$HOME/.nix-profile/bin"
            $path
          )
        '';
  };
}
