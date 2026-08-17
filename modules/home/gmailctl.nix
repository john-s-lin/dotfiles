{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.gmailctl ];

    file.".gmailctl/config.jsonnet" = {
      source = ./gmailctl/config.jsonnet;
      force = true;
    };
  };
}
