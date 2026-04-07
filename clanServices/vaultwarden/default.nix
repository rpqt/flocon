{ ... }:
{
  _class = "clan.service";
  manifest.name = "vaultwarden";
  manifest.description = "Bitwarden-compatible password manager";
  manifest.exports.out = [ "endpoints" ];

  roles.default = {
    perInstance =
      {
        meta,
        mkExports,
        ...
      }:
      let
        host = "vaultwarden.${meta.domain}";
      in
      {
        exports = mkExports {
          endpoints.hosts = [ host ];
        };

        nixosModule = {
          services.vaultwarden = {
            enable = true;
            domain = host;
            configureNginx = true;
          };

          clan.core.state.vaultwarden.folders = [ "/var/lib/vaultwarden" ];
        };
      };
  };
}
