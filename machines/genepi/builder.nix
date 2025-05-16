{ keys, ... }:
{
  imports = [
    ../../modules/remote-builder.nix
  ];

  roles.remote-builder = {
    enable = true;
    authorizedKeys = [ keys.hosts.haze ];
  };
}
