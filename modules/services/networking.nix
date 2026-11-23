{ ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        FastConnectable = true;
      };
      Policy = {
        ReconnectAttempts = 7;
        ReconnectIntervals = "1,2,4,8,16,32,64";
      };
    };
    input = {
      General = {
        IdleTimeout = 0;
      };
    };
  };

  networking = {
    networkmanager.enable = true;
    nameservers = [
      # "192.168.2.100"
      "1.1.1.3"
      "1.0.0.3"
    ];
  };

  # Allows detecting network-attached devices
  services.avahi.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
