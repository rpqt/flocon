{ config, ... }:
let
  tld = "val";
  domain = "glance.${tld}";
in
{
  services.glance = {
    enable = true;
    settings = (import ./glance-config.nix) { inherit tld; };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass =
      "http://127.0.0.1:${toString config.services.glance.settings.server.port}";
  };

  security.acme.certs.${domain}.server = "https://ca.${tld}/acme/acme/directory";
}
