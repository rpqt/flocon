{ config, ... }:
{
  networking.firewall = {
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
