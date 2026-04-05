{ lib, self, ... }:
{
  clan.inventory.instances."borgbackup-storagebox" = {
    module.input = "clan-core";
    module.name = "borgbackup";

    roles.client.machines = lib.genAttrs [ "crocus" "genepi" "renoir" "verbena" ] (
      machine:
      let
        config = self.nixosConfigurations.${machine}.config;
        user = "u422292";
        host = "${user}.your-storagebox.de";
      in
      {
        settings.destinations."storagebox-${config.networking.hostName}" = {
          repo = "${user}@${host}:./borgbackup/${config.networking.hostName}";
          rsh = "ssh -oPort=23 -i ${
            config.clan.core.vars.generators.borgbackup.files."borgbackup.ssh".path
          } -oStrictHostKeyChecking=accept-new";
        };
      }
    );
    roles.client.extraModules = [
      {
        programs.ssh.knownHosts =
          let
            user = "u422292";
            host = "${user}.your-storagebox.de";
          in
          {
            storagebox-ed25519 = {
              hostNames = [ "[${host}]:23" ];
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";
            };
          };
      }

    ];
    roles.server.machines = { };
  };
}
