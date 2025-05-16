{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@rpqt.fr";
  };

  age.secrets.gandi.file = ../../secrets/gandi.age;

  security.acme = {
    certs."home.rpqt.fr" = {
      group = config.services.nginx.group;

      domain = "home.rpqt.fr";
      extraDomainNames = [ "*.home.rpqt.fr" ];
      dnsProvider = "gandiv5";
      dnsPropagationCheck = true;
      environmentFile = config.age.secrets.gandi.path;
    };
  };
}
