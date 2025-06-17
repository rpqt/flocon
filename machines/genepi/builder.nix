let
  keys = import ../../parts/keys.nix;
in
{
  imports = [
    ../../modules/remote-builder.nix
  ];

  roles.remote-builder = {
    enable = true;
    authorizedKeys = [ keys.hosts.haze ];
  };
}
