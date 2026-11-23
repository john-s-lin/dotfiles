{ ... }:
{
  programs.git = {
    enable = true;
    includes = [ { path = "~/.gitconfig.local"; } ];
    settings = {
      init = {
        defaultBranch = "main";
      };
      pager = {
        branch = false;
      };
      push = {
        autoSetupRemote = true;
      };
      gpg = {
        format = "ssh";
      };
      pull = {
        rebase = true;
      };
    };
  };
}
