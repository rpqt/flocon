let
  keys = import ../parts/keys.nix;

  keysForGenepi = [
    keys.hosts.genepi
    keys.rpqt.haze
  ];
in
{
  "gandi.age".publicKeys = keysForGenepi;

  # Storagebox sub-account password
  "restic-genepi-storagebox-password.age".publicKeys = keysForGenepi;

  # Restic repository key
  "restic-genepi-storagebox-key.age".publicKeys = keysForGenepi;
}
