{ config, ... }:
let
  domain = "actual.val";
in
{
  services.actual = {
    enable = true;
    settings = {
      hostname = "127.0.0.1";
      port = 5555;
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass =
      "http://127.0.0.1:${builtins.toString config.services.actual.settings.port}";
  };

  security.acme.certs.${domain}.server = "https://ca.val/acme/acme/directory";

  clan.core.state.actual.folders = [ "/var/lib/actual" ];
}
