{
  services.nginx.virtualHosts."lounge.home.rpqt.fr" = {
    useACMEHost = "home.rpqt.fr";
    forceSSL = true;
    root = "/var/www/lounge";
  };
}
