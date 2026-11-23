{ config, lib, ... }:
{
  options.dotfiles.services.tailscale.ssh.enable = lib.mkEnableOption "Tailscale SSH (--ssh)";

  config = {
    services.tailscale = {
      enable = true;
      extraSetFlags = lib.mkIf config.dotfiles.services.tailscale.ssh.enable [ "--ssh" ];
    };

    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
