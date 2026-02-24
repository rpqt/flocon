{ ... }:
{
  _class = "clan.service";
  manifest.name = "dns";
  manifest.categories = [ "Network" ];
  manifest.description = "Clan-internal DNS and service exposure";
  manifest.readme = ''
    # How it works

    Every dns-request from a clan machine lands at systemd-resolved and it resolves (forwards) requests with the following priority:

    1. /etc/hosts file
    2. Local authority nameserver (if tld is ''${config.clan.core.settings.domain})
    3. Configured system's dns-servers e.g. `networking.nameservers`

    The local authority nameserver is configured to answer requests only from localhost and it hosts the zonefile for the clan domain.

    For external requests, the server role must be deployed/configured.

    # Usage

    ```nix
    # clan.nix
    inventory.instances.dns = {
      module.input = "self";
      module.name = "@schallerclan/dns";

      roles.server = {
        tags = [ "serve_dns" ];
        extraModules = [ modules/blocky.nix ];

        machines."myMachine01" = {};
      };

      roles.default.machines."myMachine01".settings = {
        records = {
          A = [
            "203.0.113.1" # www
            "10.0.0.1" # wireguard
            "100.0.0.1" # tailscale
          ];
          AAAA = [
            "2001:db8::1" # www
            "fc00::1" # wireguard
            "fd00::1" # tailscale
            "400::1" # mycelium
            "200::1" # yggdrasil
          ];
        };
      };

      roles.default.machines."myMachine02".settings = {
        records = {
          A = [
            "203.0.113.2" # www
            "10.0.0.2" # wireguard
            "100.0.0.2" # tailscale
          ];
          AAAA = [
            "2001:db8::2" # www
            "fc00::2" # wireguard
            "fd00::2" # tailscale
            "400::2" # mycelium
            "200::2" # yggdrasil
          ];
        };

        services = [ "foo" ];
      };
    };
    ```

    The example will result into the following records, in the zonefile:

    ```
    myMachine01.clan A    203.0.113.1
    myMachine01.clan A    10.0.0.1
    myMachine01.clan A    100.0.0.1
    myMachine01.clan AAAA 2001:db8::1
    myMachine01.clan AAAA fd00::1
    myMachine01.clan AAAA fc00::1
    myMachine01.clan AAAA 400::1
    myMachine01.clan AAAA 200::1

    myMachine02.clan A    203.0.113.2
    myMachine02.clan A    10.0.0.2
    myMachine02.clan A    100.0.0.2
    myMachine02.clan AAAA 2001:db8::2
    myMachine02.clan AAAA fd00::2
    myMachine02.clan AAAA fc00::2
    myMachine02.clan AAAA 400::2
    myMachine02.clan AAAA 200::2

    foo.clan A    203.0.113.2
    foo.clan A    10.0.0.2
    foo.clan A    100.0.0.2
    foo.clan AAAA 2001:db8::2
    foo.clan AAAA fd00::2
    foo.clan AAAA fc00::2
    foo.clan AAAA 400::2
    foo.clan AAAA 200::2
    ```
  '';

  roles.default = {
    description = ''
      Machines in this role will take part in dns.

      Machines will
      - register their hostname with the configured records
      - register their `settings.services` with the configured records
      - be able to resolve all records locally
    '';

    interface =
      { lib, ... }:
      {
        options = with lib.types; {
          records = lib.mkOption {
            type = attrsOf (coercedTo str (s: [ s ]) (listOf str));
            default = { };
            description = ''
              DNS records for the machine and all its services.

              Technically, no restrictions on which dns records can be used. But
              intended for A and AAAA records.
            '';
            example = {
              A = [
                "203.0.113.2" # www
                "10.0.0.2" # wireguard
                "100.0.0.2" # tailscale
              ];
              AAAA = [
                "2001:db8::2" # www
                "fd28:387a:6e:df00::2" # wireguard
                "fd7a:115c:a1e0::2" # tailscale
                "400::2" # mycelium
                "200::2" # yggdrasil
              ];
            };
          };

          services = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              Service endpoints this host exposes (without TLD). Each entry will be resolved to <service>.''${config.clan.core.settings.domain}.
            '';
          };
        };
      };

    perInstance =
      { roles, settings, ... }:
      {
        nixosModule =
          {
            lib,
            config,
            pkgs,
            ...
          }:
          {
            networking.nameservers = [ "[::1]:1053#${config.clan.core.settings.domain}" ];

            services.resolved.domains = [ "~${config.clan.core.settings.domain}" ];

            services.unbound = {
              enable = true;

              # https://unbound.docs.nlnetlabs.nl/en/latest/manpages/unbound.conf.html
              settings = {
                server = {
                  port = 1053;
                  verbosity = 2;
                  interface = [
                    "127.0.0.1"
                    "::1"
                  ];
                  access-control = [
                    "127.0.0.0/8 allow"
                    "::0/64 allow"
                  ];
                  do-not-query-localhost = false;
                  domain-insecure = [ "${config.clan.core.settings.domain}." ];
                };

                auth-zone = [
                  {
                    name = config.clan.core.settings.domain;
                    zonefile = "${pkgs.writeTextFile (
                      let
                        nsRecords = lib.lists.concatLists (
                          #                                  ↓ this machine
                          lib.lists.forEach (lib.attrsToList settings.records) (
                            record: lib.lists.forEach record.value (value: "ns ${record.name} ${value}")
                          )
                        );

                        machineRecords = lib.lists.concatLists (
                          lib.lists.forEach (lib.attrNames roles.default.machines) (
                            machine:
                            lib.lists.concatLists (
                              lib.lists.forEach (lib.attrsToList roles.default.machines.${machine}.settings.records) (
                                record: lib.lists.forEach record.value (value: "${machine} ${record.name} ${value}")
                              )
                            )
                          )
                        );

                        serviceRecords = lib.lists.concatLists (
                          lib.lists.forEach (lib.attrNames roles.default.machines) (
                            machine:
                            lib.lists.concatLists (
                              lib.lists.forEach roles.default.machines.${machine}.settings.services (
                                service:
                                lib.lists.concatLists (
                                  lib.lists.forEach (lib.attrsToList roles.default.machines.${machine}.settings.records) (
                                    record: lib.lists.forEach record.value (value: "${service} ${record.name} ${value} ; ${machine}")
                                  )
                                )
                              )
                            )
                          )
                        );
                      in
                      {
                        name = "db.${config.clan.core.settings.domain}.zone";
                        text = lib.strings.concatStringsSep "\n\n" [
                          ''
                            $ORIGIN ${config.clan.core.settings.domain}.
                            $TTL 3600
                            @ IN SOA ns admin 1 7200 3600 1209600 3600
                            @ IN NS ns
                          ''
                          (lib.strings.concatStringsSep "\n" nsRecords)
                          (lib.strings.concatStringsSep "\n" machineRecords)
                          (lib.strings.concatStringsSep "\n" serviceRecords)
                        ];
                      }
                    )}";
                  }
                ];
              };
            };
          };
      };
  };

  roles.server = {
    description = ''
      Additional role upon `roles.default`.

      Machines in this role will serve [blocky](https://0xerr0r.github.io/blocky/latest/) as a dns server on port 53, including all dns records in the default role.

      For blocky (dns server) configuration, make a new file at e.g. `modules/blocky.nix` and include it with `roles.server.extraModules [ modules/blocky.nix ];`

      ```nix
      # modules/blocky.nix
      {
        # https://0xerr0r.github.io/blocky/latest/configuration
        services.blocky.settings = {
          # ...
        };
      }
      ```

      With `systemctl status blocky.service` check, if blocky was configured correctly.
    '';

    perInstance = {
      nixosModule =
        { lib, config, ... }:
        {
          networking.firewall.allowedTCPPorts = [ 53 ];
          networking.firewall.allowedUDPPorts = [ 53 ];

          services.resolved.enable = false;
          services.blocky = {
            enable = true;
            settings = {
              upstreams.groups.default = lib.mkDefault [
                # quad9
                "9.9.9.9"
                "149.112.112.112"
                "2620:fe::fe"
                "2620:fe::9"
                # cloudflare
                "1.1.1.1"
                "1.0.0.1"
                "2606:4700:4700::1111"
                "2606:4700:4700::1001"
              ];

              conditional.mapping = {
                ${config.clan.core.settings.domain} = "tcp+udp:[::1]:1053";
              };
            };
          };
        };
    };
  };

  perMachine = {
    nixosModule = {
      services.tailscale.extraUpFlags = [ "--accept-dns=false" ];
    };
  };
}
