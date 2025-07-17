{ config, keys, ... }:
{
  services.radicle = {
    enable = true;
    privateKeyFile = config.clan.core.vars.generators.radicle.files.radicle-private-key.path;
    publicKey = keys.services.radicle;
    node = {
      openFirewall = true;
    };
    httpd = {
      enable = true;
      nginx = {
        serverName = "radicle.rpqt.fr";
        enableACME = true;
        forceSSL = true;
      };
    };
  };

  clan.core.vars.generators.radicle = {
    prompts.radicle-private-key = {
      description = "radicle node private key";
      type = "hidden";
      persist = true;
    };
  };
}
