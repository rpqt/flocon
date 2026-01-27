{ config, lib, ... }:
let
  cfg = config.services.forgejo;
in
{
  services.forgejo = {
    enable = true;
    lfs.enable = true;

    settings = {
      # storage = {
      # };

      server = {
        ROOT_URL = "https://${cfg.settings.server.DOMAIN}";
        DOMAIN = "git.rpqt.fr";
        HTTP_PORT = 3001;
      };

      session.PROVIDER = "db";
      session.COOKIE_SECURE = true;

      service.DISABLE_REGISTRATION = true;

      # Create a repository by pushing to it
      repository.ENABLE_PUSH_CREATE_USER = true;
    };
  };

  systemd.services.forgejo.environment = {
    FORGEJO__storage__STORAGE_TYPE = "minio";
    FORGEJO__storage__MINIO_ENDPOINT = "localhost:3900";
    FORGEJO__storage__MINIO_BUCKET = "forgejo";
    FORGEJO__storage__MINIO_LOCATION = "garage";
    FORGEJO__storage__MINIO_USE_SSL = "false";
  };

  systemd.services.forgejo.serviceConfig = {
    LoadCredential = [
      "minio_access_key_id:${config.clan.core.vars.generators.forgejo-s3-storage.files.access-key-id.path}"
      "minio_secret_access_key:${config.clan.core.vars.generators.forgejo-s3-storage.files.access-key-secret.path}"
    ];
    Environment = [
      "FORGEJO__storage__MINIO_ACCESS_KEY_ID__FILE=%d/minio_access_key_id"
      "FORGEJO__storage__MINIO_SECRET_ACCESS_KEY__FILE=%d/minio_secret_access_key"
    ];
  };

  clan.core.vars.generators.forgejo-s3-storage = {
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
  };

  clan.core.state.forgejo.folders = [ config.services.forgejo.stateDir ];

  services.nginx.virtualHosts."git.rpqt.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString (cfg.settings.server.HTTP_PORT)}";
    };
  };

  security.acme.certs."git.rpqt.fr" = {
    email = "admin@rpqt.fr";
  };
}
