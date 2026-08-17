{ pkgs, ... }:
{
  programs.zsh.oh-my-zsh.theme = "robbyrussell";

  programs.zsh.initContent = ''
    if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
    fi
    if [ -n "$SHPOOL_SESSION_NAME" ]; then
      SHPOOL_PROMPT="%F{magenta}(shpool-$SHPOOL_SESSION_NAME)%f "
    else
      SHPOOL_PROMPT=""
    fi
    PROMPT="$SHPOOL_PROMPT%{$fg_bold[yellow]%}$USER@%m%{$reset_color%} $PROMPT"
  '';

  programs.bash = {
    enable = true;
    initExtra = ''
      if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
      fi
      if [ -n "$SHPOOL_SESSION_NAME" ]; then
        SHPOOL_PS1="\[\033[35m\](shpool-$SHPOOL_SESSION_NAME)\[\033[0m\] "
      else
        SHPOOL_PS1=""
      fi
      PS1="$SHPOOL_PS1\[\033[1;33m\]$USER@\h\[\033[0m\] ➜ \w \$ "
    '';
  };

  home.file.".terminfo" = {
    source = "${pkgs.ghostty.terminfo}/share/terminfo";
    recursive = true;
  };

  home.shellAliases = {
    lg = "lazygit";
    cat = "bat";
  };

  xdg.enable = true;
  programs.home-manager.enable = true;
}
