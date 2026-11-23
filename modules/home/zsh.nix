{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "jj"
        "vi-mode"
      ];
    };

    # Conditional configuration for Darwin on aarch64
    # Static Homebrew environment (avoids `uname` + `brew shellenv` forks on startup)
    # and ensures Nix profile paths take precedence over Homebrew.
    initContent =
      if pkgs.stdenv.hostPlatform.isDarwin then
        ''
          # Enable unique path tracking to prevent duplicates
          typeset -U path
        ''
        + lib.optionalString pkgs.stdenv.hostPlatform.isAarch64 ''

          export HOMEBREW_PREFIX="/opt/homebrew"
          export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
          export HOMEBREW_REPOSITORY="/opt/homebrew"
          fpath[1,0]="/opt/homebrew/share/zsh/site-functions"
          export INFOPATH="/opt/homebrew/share/info:''${INFOPATH:-}"
        ''
        + ''

          # Re-prioritize Nix paths to take precedence over Homebrew
          # Zsh will keep the first occurrence and remove duplicates
          path=(
            "/etc/profiles/per-user/$USER/bin"
            "$HOME/.nix-profile/bin"
            ${lib.optionalString pkgs.stdenv.hostPlatform.isAarch64 ''"/opt/homebrew/bin"
            "/opt/homebrew/sbin"''}
            $path
          )
        ''
      else
        ''
          # Enable unique path tracking to prevent duplicates
          typeset -U path
        '';
  };
}
