{
  self,
  config,
  lib,
  ...
}:
let
  domain = "home.rpqt.fr";
  machines = {
    genepi = {
      subdomains = [
        "actual"
        "assistant"
        "glance"
        "grafana"
        "images"
        "lounge"
        "pinchflat"
        "rss"
        "tw"
      ];
    };
    crocus = {
      subdomains = [
        "cloud"
      ];
    };
  };
  zerotierInterface = "zts7mq7onf";
  machinesZerotierIpRecords =
    lib.map
      (
        host:
        ''"${host}.infra.rpqt.fr. 10800 IN AAAA ${
          self.nixosConfigurations.${host}.config.clan.core.vars.generators.zerotier.files.zerotier-ip.value
        }"''
      )
      [
        "crocus"
        "genepi"
      ];
in
{
  services.resolved.enable = false;

  networking.firewall.interfaces.${zerotierInterface} = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    checkconf = true;

    settings = {
      server = {
        interface = [
          "127.0.0.1"
          "::1"
          "::0"
        ];
        access-control = [
          "127.0.0.1 allow"
          "${config.clan.core.networking.zerotier.subnet} allow"
        ];
        local-zone = [
          ''"*.home.rpqt.fr." redirect''
        ];
        local-data =
          # machinesZerotierIpRecords ++
          lib.concatMap (
            host:
            lib.map (
              subdomain:
              ''"${subdomain}.${domain}. 10800 IN AAAA ${
                self.nixosConfigurations.${host}.config.clan.core.vars.generators.zerotier.files.zerotier-ip.value
              }"''
            ) machines.${host}.subdomains
          ) (lib.attrNames machines);
        private-address = [
          "127.0.0.1/8"
          "${config.clan.core.networking.zerotier.subnet}"
        ];
        private-domain = [
          "home.rpqt.fr"
        ];
      };
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = true;
          forward-addr = [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
            "1.1.1.1@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
            "2606:4700:4700::1111@853#cloudflare-dns.com"
            "2606:4700:4700::1001@853#cloudflare-dns.com"
            "8.8.8.8#dns.google"
            "8.8.4.4#dns.google"
            "2001:4860:4860::8888#dns.google"
            "2001:4860:4860::8844#dns.google"
          ];
        }
      ];
    };
  };
}
