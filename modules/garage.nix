{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  zerotier_interface = "zts7mq7onf";
  zerotier_ip =
    self.nixosConfigurations.${config.networking.hostName}.config.clan.core.vars.generators.zerotier.files.zerotier-ip.value;
  s3_port = 3900;
  rpc_port = 3901;
  web_port = 3902;
  admin_port = 3903;
in
{
  services.garage = {
    package = pkgs.garage;
    settings = {
      metadata_dir = "/var/lib/garage/meta";
      data_dir = lib.mkDefault "/var/lib/garage/data";
      db_engine = "sqlite";

      replication_factor = 3;

      rpc_bind_addr = "[::]:${toString rpc_port}";
      rpc_public_addr = "[${zerotier_ip}]:${toString rpc_port}";

      s3_api = {
        api_bind_addr = "[${zerotier_ip}]:${toString s3_port}";
        s3_region = "garage";
        root_domain = ".s3.garage.home.rpqt.fr";
      };

      s3_web = {
        bind_addr = "127.0.0.1:${toString web_port}";
        root_domain = ".web.garage.home.rpqt.fr";
      };

      admin = {
        api_bind_addr = "[${zerotier_ip}]:${toString admin_port}";
        # TODO: use metrics_token
      };
    };
  };

  networking.firewall.interfaces.${zerotier_interface} = {
    allowedTCPPorts = [
      s3_port
      rpc_port
      admin_port
    ];
  };
}
