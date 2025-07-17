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

  systemd.services.gitea.serviceConfig = {
    EnvironmentFile = config.clan.core.vars.generators.gitea-s3-storage.files.gitea-env.path;
  };

  systemd.services.gitea.environment = {
    GITEA__storage__STORAGE_TYPE = "minio";
    GITEA__storage__MINIO_ENDPOINT = "localhost:3900";
    GITEA__storage__MINIO_BUCKET = "gitea";
    GITEA__storage__MINIO_LOCATION = "garage";
    GITEA__storage__MINIO_USE_SSL = "false";
  };

  clan.core.vars.generators.gitea-s3-storage = {
    prompts.access-key-id = {
      description = "s3 access key id";
      type = "line";
    };
    prompts.access-key-secret = {
      description = "s3 access key secret";
      type = "hidden";
    };
    files.gitea-env = {
      secret = true;
    };
    script = ''
      printf %s "GITEA__storage__MINIO_ACCESS_KEY_ID=" >> $out/gitea-env
      cat $prompts/access-key-id >> $out/gitea-env
      printf "\n%s" "GITEA__storage__MINIO_SECRET_ACCESS_KEY=" >> $out/gitea-env
      cat $prompts/access-key-secret >> $out/gitea-env
    '';
  };

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
