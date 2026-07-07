_: {
  _class = "clan.service";

  manifest = {
    name = "wakeonlan";
    description = "Adds Wake-on-LAN support to your machines, to wake them each other.";
    categories = [
      "Network"
      "System"
    ];
    readme = ''
      Further information and requirements for Wake-on-LAN under NixOS: <https://wiki.nixos.org/wiki/Wake_on_LAN>

      ```nix
      # clan.nix
      inventory.instances.wakeonlan = {
        module.name = "@schallerclan/wakeonlan";
        module.input = "schallerclan";

        roles.target.machines."myMachine1".settings.interfaces = [ "66:77:88:99:AA:BB" ];

        roles.source.tags = [ "all" ];
      };
      ```

      From another 'source' machine (within the same VLAN as myMachine1) you can then run `wakeonlan-myMachine1` to send a magic packet to wake myMachine1.
    '';
  };

  roles.target = {
    description = "Machines, that receive Wake-on-LAN packets. Enables Wake-on-LAN and opens UDP port 9.";
    interface =
      { lib, ... }:
      {
        options = with lib.types; {
          interfaces = lib.mkOption {
            type = listOf (
              coercedTo str (s: { mac = s; }) (submodule {
                options = {
                  mac = lib.mkOption {
                    type = strMatching "^[[:xdigit:]:]{17}$";
                    description = ''
                      The mac address of the interface to send to.

                      ```sh
                      ip --brief link show
                      ```
                    '';
                    example = "66:77:88:99:AA:BB";
                  };
                  broadcast = lib.mkOption {
                    type = str;
                    default = "255.255.255.255";
                    description = ''
                      The IPv4 broadcast address to send to.
                      Declare it when the router is blocking `255.255.255.255`.
                    '';
                    example = "192.168.178.255";
                  };
                };
              })
            );
            default = [ ];
            description = "A collection of interfaces to enable Wake-on-LAN on.";
            example = [
              "00:11:22:33:44:55"
              {
                mac = "66:77:88:99:AA:BB";
                broadcast = "192.168.178.255";
              }
            ];
          };
        };
      };
    perInstance =
      { settings, ... }:
      {
        nixosModule =
          { lib, ... }:
          with lib;
          {
            systemd.network.links."50-wakeonlan" = {
              matchConfig.MACAddress = concatStringsSep " " (map (i: i.mac) settings.interfaces);
              linkConfig.WakeOnLan = "magic";
            };

            networking.firewall.allowedUDPPorts = [ 9 ];
          };
      };
  };

  roles.source = {
    description = ''
      Machines to send Wake-on-LAN packets from. e.g.:

      ```sh
      wakeonlan [--ip=255.255.255.255] <target-mac>
      wakeonlan-myMachine1
      wakeonlan-myMachine2
      ```
    '';
    perInstance =
      { roles, ... }:
      {
        nixosModule =
          { lib, pkgs, ... }:
          with lib;
          {
            environment.systemPackages =
              with pkgs;
              [ wakeonlan ]
              ++ (forEach (attrNames roles.target.machines) (
                machine:
                pkgs.writeShellApplication {
                  name = "wakeonlan-${machine}";
                  runtimeInputs = [ wakeonlan ];
                  text = concatStringsSep "\n" (
                    forEach roles.target.machines.${machine}.settings.interfaces (
                      i: "wakeonlan --ip=${i.broadcast} ${i.mac}"
                    )
                  );
                }
              ));
          };
      };
  };
}

