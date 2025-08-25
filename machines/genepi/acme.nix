{ config, ... }:
{
  imports = [
    ../../modules/gandi.nix
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@rpqt.fr";
  };

  security.acme = {
    certs."home.rpqt.fr" = {
      group = config.services.nginx.group;
      domain = "home.rpqt.fr";
      extraDomainNames = [ "*.home.rpqt.fr" ];
      dnsProvider = "gandiv5";
      dnsPropagationCheck = true;
      environmentFile = config.clan.core.vars.generators.gandi.files.gandi-env.path;
      email = "admin@rpqt.fr";
      dnsResolver = "1.1.1.1:53";
    };
  };

  clan.core.vars.generators.gandi.files.gandi-env.owner = "acme";
}
