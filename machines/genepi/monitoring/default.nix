{
  imports = [
    ./grafana.nix
  ];

  networking.firewall.interfaces."zts7mq7onf".allowedTCPPorts = [
    9090 # prometheus web interface
  ];
}
