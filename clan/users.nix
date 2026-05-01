{ self, ... }:
{
  clan.inventory.instances.user-rpqt = {
    module.input = "clan-core";
    module.name = "users";
    roles.default.machines = {
      haze = { };
      crocus = { };
      genepi = { };
      renoir = { };
    };
    roles.default.settings = {
      user = "rpqt";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGa8R8obgptefcp27Cdp9bc2fiyc9x0oTfMsTPFp2ktE rpqt@haze"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICoam8/MoZkXbjXOYAQLtoFDbAAV6JJhPis/KAwJ/7Q5 rpqt@renoir"
      ];
    };
    roles.default.extraModules = [
      self.nixosModules.user-rpqt
    ];
  };
}
