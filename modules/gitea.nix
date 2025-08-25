{ config, ... }:
{
  services.gitea = {
    enable = true;
    lfs.enable = true;

    settings = {
      # storage = {
      # };

      server = {
        ROOT_URL = "https://git.turifer.dev";
        DOMAIN = "git.turifer.dev";
      };

      session.PROVIDER = "db";
      session.COOKIE_SECURE = true;

      service.DISABLE_REGISTRATION = true;

      # Create a repository by pushing to it
      repository.ENABLE_PUSH_CREATE_USER = true;
    };
  };

  systemd.services.gitea.environment = {
    GITEA__storage__STORAGE_TYPE = "minio";
    GITEA__storage__MINIO_ENDPOINT = "localhost:3900";
    GITEA__storage__MINIO_BUCKET = "gitea";
    GITEA__storage__MINIO_LOCATION = "garage";
    GITEA__storage__MINIO_USE_SSL = "false";
  };

  systemd.services.gitea.serviceConfig = {
    LoadCredential = [
      "minio_access_key_id:${config.clan.core.vars.generators.gitea-s3-storage.files.access-key-id.path}"
      "minio_secret_access_key:${config.clan.core.vars.generators.gitea-s3-storage.files.access-key-secret.path}"
    ];
    Environment = [
      "GITEA__storage__MINIO_ACCESS_KEY_ID=%d/minio_access_key_id"
      "GITEA__storage__MINIO_SECRET_ACCESS_KEY=%d/minio_secret_access_key"
    ];
  };

  clan.core.vars.generators.gitea-s3-storage = {
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

  clan.core.state.gitea.folders = [ config.services.gitea.stateDir ];

  services.nginx.virtualHosts."git.turifer.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString (config.services.gitea.settings.server.HTTP_PORT)}";
    };
  };

  security.acme.certs."git.turifer.dev" = {
    email = "admin@turifer.dev";
  };
}
