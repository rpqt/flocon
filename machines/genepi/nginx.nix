{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  networking.firewall.interfaces."zts7mq7onf".allowedTCPPorts = [ 443 ];
  networking.firewall.interfaces."wireguard".allowedTCPPorts = [
    80
    443
  ];
}
