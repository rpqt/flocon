{
  config,
  keys,
  pkgs,
  ...
}:
let
  storagebox-user = "u422292-sub1";
  storagebox-host = "${storagebox-user}.your-storagebox.de";
in
{
  environment.systemPackages = [
    pkgs.sshpass
  ];

  age.secrets.restic-genepi-storagebox-key.file = ../../secrets/restic-genepi-storagebox-key.age;
  age.secrets.restic-genepi-storagebox-password.file = ../../secrets/restic-genepi-storagebox-password.age;

  programs.ssh.knownHosts = {
    "${storagebox-host}".publicKey = keys.hosts.storagebox;
  };

  services.restic.backups = {
    storagebox-nightly = {
      initialize = true;
      paths = [
        "/persist"
      ];
      passwordFile = config.age.secrets.restic-genepi-storagebox-key.path;
      repository = "sftp://${storagebox-user}@${storagebox-host}";
      extraOptions = [
        "sftp.command='${pkgs.sshpass}/bin/sshpass -f ${config.age.secrets.restic-genepi-storagebox-password.path} -- ssh ${storagebox-host} -l ${storagebox-user} -s sftp'"
      ];
      timerConfig = {
        OnCalendar = "03:00";
        RandomizedDelaySec = "1h";
      };
    };
  };
}
