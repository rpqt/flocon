{
  config,
  pkgs,
  ...
}:
let
  tld = "val";
  domain = "pinchflat.${tld}";
in
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

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://127.0.0.1:${builtins.toString config.services.pinchflat.port}";
  };

  security.acme.certs.${domain}.server = "https://ca.${tld}/acme/acme/directory";
}
