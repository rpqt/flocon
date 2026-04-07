{ ... }:
{
  _class = "clan.service";
  manifest.name = "home-assistant";
  manifest.description = "Home Assistant";
  manifest.exports.out = [ "endpoints" ];

  roles.default = {
    perInstance =
      {
        meta,
        mkExports,
        ...
      }:
      let
        host = "assistant.${meta.domain}";
      in
      {
        exports = mkExports {
          endpoints.hosts = [ host ];
        };

        nixosModule = (
          { config, ... }:
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
                # Shelly Plug
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

            services.nginx.virtualHosts.${host} = {
              forceSSL = true;
              extraConfig = ''
                proxy_buffering off;
              '';
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString config.services.home-assistant.config.http.server_port}";
                proxyWebsockets = true;
              };
            };
          }
        );
      };
  };
}
