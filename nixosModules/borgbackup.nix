{ config, self, ... }:
let
  user = "u422292";
  sub-user = "${user}";
  host = "${user}.your-storagebox.de";
in
{
  imports = [
    self.nixosModules.storagebox
    self.inputs.clan-core.clanModules.borgbackup
  ];

  clan.borgbackup.destinations."storagebox-${config.networking.hostName}" = {
    repo = "${sub-user}@${host}:./borgbackup/${config.networking.hostName}";
    rsh = "ssh -oPort=23 -i ${config.clan.core.vars.generators.borgbackup.files."borgbackup.ssh".path}";
  };
}
