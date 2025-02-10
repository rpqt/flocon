let
  keys = import ../../../parts/keys.nix;
in
{
  "syncthing-key.pem.age".publicKeys = [ keys.hosts.haze ];
  "syncthing-cert.pem.age".publicKeys = [ keys.hosts.haze ];
}
