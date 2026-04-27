{ ... }:
{ lib, ... }:
{
  _class = "clan.service";
  manifest.name = "glance";
  manifest.description = "Glance dashboard";
  manifest.exports.out = [ "endpoints" ];

  roles.default = {
    interface.options = {
      glance = lib.mkOption {
        type = lib.types.attrs;
        description = "Glance configuration, passed to services.glance.settings";
        example = ''
          theme = {
            light = true;
            background-color = "0 0 95";
            primary-color = "0 0 10";
            negative-color = "0 90 50";
          };
        '';
      };
    };

    perInstance =
      {
        meta,
        mkExports,
        settings,
        ...
      }:
      let
        host = "glance.${meta.domain}";
      in
      {
        exports = mkExports {
          endpoints.hosts = [ host ];
        };

        nixosModule = (
          { config, ... }:
          {
            services.glance = {
              enable = true;
              settings = settings.glance;
            };

            services.nginx.virtualHosts.${host} = {
              forceSSL = true;
              enableACME = true;
              locations."/".proxyPass =
                "http://127.0.0.1:${toString config.services.glance.settings.server.port}";
            };
          }
        );
      };
  };
}
