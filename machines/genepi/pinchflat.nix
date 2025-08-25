{
  config,
  pkgs,
  ...
}:
{
  services.pinchflat = {
    enable = true;
    secretsFile = config.clan.core.vars.generators.pinchflat.files.env.path;
    mediaDir = "/home/rpqt/Music";
  };

  clan.core.vars.generators.pinchflat = {
    files.env = { };
    runtimeInputs = [
      pkgs.coreutils
      pkgs.openssl
    ];
    script = ''
      echo "$SECRET_KEY_BASE=$(openssl rand -hex 64)" > "$out"/env
    '';
  };

  clan.core.state.pinchflat.folders = [ "/var/lib/pinchflat" ];

  services.nginx.virtualHosts."pinchflat.home.rpqt.fr" = {
    forceSSL = true;
    useACMEHost = "home.rpqt.fr";
    locations."/".proxyPass = "http://127.0.0.1:${builtins.toString config.services.pinchflat.port}";
  };
}
