{
  config,
  pkgs,
  self,
  ...
}:
let
  zerotier_interface = "zts7mq7onf";
  zerotier_ip =
    self.nixosConfigurations.${config.networking.hostName}.config.clan.core.vars.generators.zerotier.files.zerotier-ip.value;
in
{
  services.garage = {
    package = pkgs.garage;
    settings = {
      metadata_dir = "/var/lib/garage/meta";
      data_dir = "/var/lib/garage/data";
      db_engine = "sqlite";

      replication_factor = 2;

      rpc_bind_addr = "[::]:3901";
      rpc_public_addr = "[${zerotier_ip}]:3901";

      s3_api = {
        api_bind_addr = "127.0.0.1:3900";
        s3_region = "garage";
        root_domain = ".s3.garage.home.rpqt.fr";
      };

      s3_web = {
        bind_addr = "127.0.0.1:3902";
        root_domain = ".web.garage.home.rpqt.fr";
      };

      admin = {
        api_bind_addr = "127.0.0.1:3903";
      };
    };
  };

  networking.firewall.interfaces.${zerotier_interface} = {
    allowedTCPPorts = [ 3901 ];
  };
}
