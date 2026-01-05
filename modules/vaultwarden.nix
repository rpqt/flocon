{
  config,
  ...
}:
{
  services.vaultwarden = {
    enable = true;
    domain = "vaultwarden.val";
    configureNginx = true;
  };

  services.nginx.virtualHosts.${config.services.vaultwarden.domain} = {
    enableACME = true;
  };

  security.acme.certs.${config.services.vaultwarden.domain}.server =
    "https://ca.val/acme/acme/directory";
}
