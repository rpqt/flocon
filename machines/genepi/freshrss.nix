{ config, ... }:
let
  tld = "val";
  domain = "rss.${tld}";
in
{
  services.freshrss = {
    enable = true;
    baseUrl = "https://${domain}";
    virtualHost = "${domain}";

    defaultUser = "rpqt";
    passwordFile = config.clan.core.vars.generators.freshrss.files.freshrss-password.path;
  };

  services.nginx.virtualHosts.${config.services.freshrss.virtualHost} = {
    forceSSL = true;
    enableACME = true;
  };

  security.acme.certs.${domain}.server = "https://ca.${tld}/acme/acme/directory";

  clan.core.vars.generators.freshrss = {
    prompts.freshrss-password = {
      description = "freshrss default user password";
      type = "hidden";
      persist = true;
    };
    files.freshrss-password.owner = config.services.freshrss.user;
  };
}
