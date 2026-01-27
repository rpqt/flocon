{
  config,
  lib,
  pkgs,
  ...
}:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = lib.mkDefault "admin@rpqt.fr";
  };

  # security.acme = {
  #   certs."home.rpqt.fr" = {
  #     group = config.services.nginx.group;
  #     domain = "home.rpqt.fr";
  #     extraDomainNames = [ "*.home.rpqt.fr" ];
  #     dnsProvider = "rfc2136";
  #     dnsPropagationCheck = true;
  #     credentialFiles = {
  #       RFC2136_TSIG_SECRET_FILE = config.clan.core.vars.generators.coredns.files.tsig-key.path;
  #     };
  #     environmentFile = pkgs.writeFile ''
  #       RFC2136_NAMESERVER=fd28:387a:90:c400::1
  #     '';
  #     email = "admin@rpqt.fr";
  #     dnsResolver = "1.1.1.1:53";
  #     server = "https://acme-staging-v02.api.letsencrypt.org/directory"; # TODO: use production api
  # };
  # };

  # clan.core.vars.generators.coredns.files.tsig-key.group = "acme";
  # clan.core.vars.generators.coredns.files.tsig-key.mode = "0440";
}
