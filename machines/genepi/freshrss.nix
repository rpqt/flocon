{ config, ... }:
let
  domain = "home.rpqt.fr";
  subdomain = "rss.${domain}";
in
{
  services.freshrss = {
    enable = true;
    baseUrl = "https://${subdomain}";
    virtualHost = "${subdomain}";

    defaultUser = "rpqt";
    passwordFile = config.clan.core.vars.generators.freshrss.files.freshrss-password.path;
  };

  services.nginx.virtualHosts.${config.services.freshrss.virtualHost} = {
    forceSSL = true;
    useACMEHost = "${domain}";
  };

  clan.core.vars.generators.freshrss = {
    prompts.freshrss-password = {
      description = "freshrss default user password";
      type = "hidden";
      persist = true;
    };
    files.freshrss-password.owner = config.services.freshrss.user;
  };
}
