let
  tld = "val";
  domain = "lounge.${tld}";
in
{
  services.nginx.virtualHosts.${domain} = {
    enableACME = true;
    forceSSL = true;
    root = "/var/www/lounge";
  };

  security.acme.certs.${domain}.server = "https://ca.${tld}/acme/acme/directory";
}
