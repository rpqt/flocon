let
  keys = import ../parts/keys.nix;
in
{
  "gandi.age".publicKeys = [
    keys.hosts.genepi
    keys.rpqt.haze
  ];
}
