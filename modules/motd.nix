{ config, ... }:
{
  users.motd = ''
    Welcome to ${config.networking.hostName}!
  '';
}
