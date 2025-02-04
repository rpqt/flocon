{ config, keys, ... }:
{
  services.radicle = {
    enable = true;
    privateKeyFile = config.age.secrets.radicle-private-key.path;
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

  age.secrets.radicle-private-key.file = ../../secrets/radicle-private-key.age;
}
