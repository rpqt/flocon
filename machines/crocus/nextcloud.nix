{ config, ... }:
let
  domain = "home.rpqt.fr";
  fqdn = "cloud.${domain}";
in
{
  imports = [
    ../../modules/acme-home.nix
  ];

  services.nextcloud = {
    enable = true;
    hostName = fqdn;
    https = true;
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      # admin user is only for the initial setup
      adminuser = "root";
      adminpassFile = config.clan.core.vars.generators.nextcloud.files.admin-password.path;
      objectstore.s3 = {
        enable = true;
        bucket = "nextcloud";
        key = config.clan.core.vars.generators.nextcloud-s3-storage.files.access-key-id.value;
        secretFile = config.clan.core.vars.generators.nextcloud-s3-storage.files.access-key-secret.path;
        hostname = "127.0.0.1";
        port = 3900;
        useSsl = false;
        region = "garage";
        usePathStyle = true;
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    useACMEHost = domain;
  };

  clan.core.vars.generators.nextcloud = {
    prompts.admin-password = {
      description = "nextcloud admin password";
      type = "hidden";
      persist = true;
    };
    files.admin-password.owner = "nextcloud";
  };

  clan.core.vars.generators.nextcloud-s3-storage = {
    prompts.access-key-id = {
      description = "s3 access key id";
      type = "line";
      persist = true;
    };
    prompts.access-key-secret = {
      description = "s3 access key secret";
      type = "hidden";
      persist = true;
    };
    files.access-key-id.secret = false;
    files.access-key-secret.owner = "nextcloud";
  };
}
