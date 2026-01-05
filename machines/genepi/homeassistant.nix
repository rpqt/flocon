{ config, ... }:
let
  tld = "val";
  domain = "assistant.${tld}";
in
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # For fast zlib compression
      "isal"
      "shelly"
    ];
    config = {
      default_config = { };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" ];
      };
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    extraConfig = ''
      proxy_buffering off;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.home-assistant.config.http.server_port}";
      proxyWebsockets = true;
    };
  };

  security.acme.certs.${domain}.server = "https://ca.${tld}/acme/acme/directory";
}
