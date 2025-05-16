{ config, ... }:
let
  domain = "home.rpqt.fr";
  subdomain = "rss.${domain}";
in
{
  age.secrets.freshrss = {
    file = ../../secrets/freshrss.age;
    mode = "700";
    owner = config.services.freshrss.user;
  };

  services.freshrss = {
    enable = true;
    baseUrl = "https://${subdomain}";
    virtualHost = "${subdomain}";

    defaultUser = "rpqt";
    passwordFile = config.age.secrets.freshrss.path;
  };

  services.nginx.virtualHosts.${config.services.freshrss.virtualHost} = {
    forceSSL = true;
    useACMEHost = "${domain}";
  };
}
