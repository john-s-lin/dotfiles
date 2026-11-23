{ config, ... }:
{
  services.tailscale = {
    enable = true;
    # Declaratively enable Tailscale SSH so both interactive SSH and CI
    # push-deploys (tag:ci -> tag:rpi) work without committing SSH keys to git.
    extraSetFlags = [ "--ssh" ];
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
