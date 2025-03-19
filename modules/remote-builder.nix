{ config, lib, ... }:
let
  cfg = config.roles.remote-builder;
in
{
  options = {
    roles.remote-builder = {
      enable = lib.mkEnableOption {
        description = "Whether to allow remote building on this machine";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "nixremote";
        example = "remote-builder";
        description = "The name of the user used to run the builds";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.user}";
        example = "remote-builder";
        description = "The group of the user used to run the builds";
      };

      authorizedKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "ssh-ed25519 AAAA... user@host" ];
        description = "List of SSH keys authorized to run builds on this machine";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users."${cfg.user}" = {
      createHome = true;
      home = "/home/${cfg.user}";
      isSystemUser = true;
      group = cfg.group;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };

    users.groups.${cfg.user} = { };

    nix.settings.trusted-users = [ cfg.user ];
  };
}
