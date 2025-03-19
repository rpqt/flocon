{ keys, ... }:
{
  roles.remote-builder = {
    enable = true;
    authorizedKeys = [ keys.hosts.haze ];
  };
}
