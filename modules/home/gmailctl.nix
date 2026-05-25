{ ... }:
{
  home.file.".gmailctl/config.jsonnet" = {
    source = ./gmailctl/config.jsonnet;
    force = true;
  };
}
