{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  home.shellAliases = {
    fcat = "fzf --preview 'bat --style=plain --color=always {}' --preview-window=right:50% --bind 'enter:execute($EDITOR {})+abort'";
  };
}
