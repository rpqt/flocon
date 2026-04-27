{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  networking.firewall.interfaces."ygg".allowedTCPPorts = [
    80
    443
  ];
}
