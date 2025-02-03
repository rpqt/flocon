{ keys, ... }:
let
  username = "nixremote";
in
{
  users.users."${username}" = {
    createHome = true;
    home = "/home/${username}";
    isSystemUser = true;
    group = username;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [ keys.hosts.haze ];
  };

  users.groups."${username}" = { };

  nix.settings.trusted-users = [ username ];
}
