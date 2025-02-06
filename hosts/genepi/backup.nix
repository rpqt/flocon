{
  config,
  keys,
  pkgs,
  ...
}:
let
  storagebox-user = "u422292-sub1";
  storagebox-host = "${storagebox-user}.your-storagebox.de";
  storagebox-nightly-backup-name = "storagebox-nightly";
  storagebox-weekly-home-backup-name = "storagebox-weekly-home";
in
{
  environment.systemPackages = [
    pkgs.sshpass
  ];

  age.secrets.restic-genepi-storagebox-key.file = ../../secrets/restic-genepi-storagebox-key.age;
  age.secrets.restic-genepi-storagebox-password.file = ../../secrets/restic-genepi-storagebox-password.age;

  programs.ssh.knownHosts = {
    "${storagebox-host}".publicKey = keys.hosts.storagebox-rsa;
  };

  services.restic.backups."${storagebox-nightly-backup-name}" = {
    initialize = true;
    paths = [
      "/persist"
    ];
    exclude = [
      "/persist/@backup-snapshot"
    ];
    passwordFile = config.age.secrets.restic-genepi-storagebox-key.path;
    repository = "sftp://${storagebox-user}@${storagebox-host}/";
    extraOptions = [
      "sftp.command='${pkgs.sshpass}/bin/sshpass -f ${config.age.secrets.restic-genepi-storagebox-password.path} -- ssh ${storagebox-host} -l ${storagebox-user} -s sftp'"
    ];
    timerConfig = {
      OnCalendar = "03:00";
      RandomizedDelaySec = "1h";
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 10"
    ];
    backupPrepareCommand = ''
      set -Eeuxo pipefail
      # clean old snapshot
      if btrfs subvolume delete /persist/@backup-snapshot; then
          echo "WARNING: previous run did not cleanly finish, removing old snapshot"
      fi

      btrfs subvolume snapshot -r /persist /persist/@backup-snapshot

      umount /persist
      mount -t btrfs -o subvol=/persist/@backup-snapshot /dev/disk/by-partlabel/disk-main-root /persist
    '';
    backupCleanupCommand = ''
      btrfs subvolume delete /persist/@backup-snapshot
    '';
  };

  systemd.services."restic-backups-${storagebox-nightly-backup-name}" = {
    path = with pkgs; [
      btrfs-progs
      umount
      mount
    ];
    serviceConfig.privateMounts = true;
  };

  # Backup home
  services.restic.backups."${storagebox-weekly-home-backup-name}" = {
    initialize = true;
    paths = [
      "/home/rpqt"
    ];
    passwordFile = config.age.secrets.restic-genepi-storagebox-key.path;
    repository = "sftp://${storagebox-user}@${storagebox-host}/";
    extraOptions = [
      "sftp.command='${pkgs.sshpass}/bin/sshpass -f ${config.age.secrets.restic-genepi-storagebox-password.path} -- ssh ${storagebox-host} -l ${storagebox-user} -s sftp'"
    ];
    timerConfig = {
      OnCalendar = "Sat 03:30";
      RandomizedDelaySec = "1h";
    };
    pruneOpts = [
      "--keep-weekly 1"
      "--keep-monthly 12"
      "--keep-yearly 10"
    ];
  };
}
