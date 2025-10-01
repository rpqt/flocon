{
  config,
  pkgs,
  ...
}:
{
  services.radicle = {
    enable = true;
    privateKeyFile = config.clan.core.vars.generators.radicle.files."id_ed25519".path;
    publicKey = config.clan.core.vars.generators.radicle.files."id_ed25519.pub".value;
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
    settings = {
      # FIXME: activation fails with rad saying the config is invalid
      # web.avatarUrl = "https://rpqt.fr/favicon.svg";
      # web.description = "rpqt's radicle node";
    };
  };

  clan.core.vars.generators.radicle = {
    files."id_ed25519".secret = true;
    files."id_ed25519.pub".secret = false;
    runtimeInputs = [ pkgs.openssh ];
    script = ''
      ssh-keygen -t ed25519 -f "$out"/id_ed25519 -N "" -C "radicle"
    '';
  };

  clan.core.state.radicle.folders = [ "/var/lib/radicle" ];
}
