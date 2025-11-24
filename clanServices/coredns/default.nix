{ ... }:

{
  _class = "clan.service";
  manifest.name = "coredns";
  manifest.description = "Clan-internal DNS and service exposure";
  manifest.categories = [ "Network" ];
  manifest.readme = builtins.readFile ./README.md;

  roles.server = {
    description = "A DNS server that resolves services in the clan network.";
    interface =
      { lib, ... }:
      {
        options.tld = lib.mkOption {
          type = lib.types.str;
          default = "clan";
          description = ''
            Top-level domain for this instance. All services below this will be
            resolved internally.
          '';
        };

        options.ip = lib.mkOption {
          type = lib.types.str;
          # TODO: Set a default
          description = "IP for the DNS to listen on";
        };

        options.dnsPort = lib.mkOption {
          type = lib.types.int;
          default = 1053;
          description = "Port of the clan-internal DNS server";
        };
      };

    perInstance =
      {
        roles,
        settings,
        ...
      }:
      {
        nixosModule =
          {
            lib,
            pkgs,
            ...
          }:

          let
            hostServiceEntries =
              host:
              lib.strings.concatStringsSep "\n" (
                map (
                  service:
                  let
                    ip = roles.default.machines.${host}.settings.ip;
                    isIPv4 = addr: (builtins.match "\\." addr) != null;
                    recordType = if (isIPv4 ip) then "A" else "AAAA";
                  in
                  "${service} IN ${recordType} ${ip}   ; ${host}"
                ) roles.default.machines.${host}.settings.services
              );

            hostnameEntries = ''
              crocus 10800 IN AAAA fd28:387a:90:c400:6db2:dfc3:c376:9956
              genepi 10800 IN AAAA fd28:387a:90:c400:ab23:3d38:a148:f539
              verbena 10800 IN AAAA fd28:387a:90:c400::1
              haze 10800 IN AAAA fd28:387a:90:c400:840e:e9db:4c08:b920
            '';

            zonefile = builtins.toFile "${settings.tld}.zone" (
              ''
                $TTL 3600 ; 1 Hour
                $ORIGIN ${settings.tld}.
                ${settings.tld}. IN SOA ns1 admin.rpqt.fr. (
                	2025112300 ; serial
                	10800 ; refresh
                	3600 ; retry
                	604800 ; expire
                	300 ; minimum
                )

                ${builtins.concatStringsSep "\n" (
                  lib.lists.imap1 (i: _m: "@ 1D IN NS ns${toString i}.${settings.tld}.") (
                    lib.attrNames roles.server.machines
                  )
                )}

                ${builtins.concatStringsSep "\n" (
                  lib.lists.imap1 (i: m: "ns${toString i} 10800 IN CNAME ${m}.${settings.tld}.") (
                    lib.attrNames roles.server.machines
                  )
                )}

              ''
              + hostnameEntries
              + "\n"
              + (lib.strings.concatStringsSep "\n" (
                map (host: hostServiceEntries host) (lib.attrNames roles.default.machines)
              ))
            );
          in
          {
            networking.firewall.interfaces.wireguard = {
              allowedTCPPorts = [ settings.dnsPort ];
              allowedUDPPorts = [ settings.dnsPort ];
            };

            services.coredns = {
              enable = true;
              config =

                let
                  dnsPort = builtins.toString settings.dnsPort;
                in

                ''
                  .:${dnsPort} {
                      forward . 1.1.1.1
                      cache 30
                  }

                  ${settings.tld}:${dnsPort} {
                      file ${zonefile}
                  }
                '';
            };
          };
      };
  };

  roles.default = {
    description = "A machine that registers the 'server' role as resolver and registers services under the configured TLD in the resolver.";
    interface =
      { lib, ... }:
      {
        options.services = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Service endpoints this host exposes (without TLD). Each entry will
            be resolved to <entry>.<tld> using the configured top-level domain.
          '';
        };

        options.ip = lib.mkOption {
          type = lib.types.str;
          # TODO: Set a default
          description = "IP on which the services will listen";
        };

        options.dnsPort = lib.mkOption {
          type = lib.types.int;
          default = 1053;
          description = "Port of the clan-internal DNS server";
        };
      };

    perInstance =
      { roles, settings, ... }:
      {
        nixosModule =
          { config, lib, ... }:
          {

            networking.nameservers = map (
              m:
              let
                port = config.services.unbound.settings.port or 53;
              in
              "127.0.0.1:${toString port}#${roles.server.machines.${m}.settings.tld}"
            ) (lib.attrNames roles.server.machines);

            services.resolved.domains = map (m: "~${roles.server.machines.${m}.settings.tld}") (
              lib.attrNames roles.server.machines
            );

            services.unbound = {
              enable = true;
              resolveLocalQueries = true;
              checkconf = true;
              settings = {
                server = {
                  # port = 5353;
                  verbosity = 2;
                  interface = [ "127.0.0.1" ];
                  access-control = [ "127.0.0.0/8 allow" ];
                  do-not-query-localhost = "no";
                  domain-insecure = map (m: "${roles.server.machines.${m}.settings.tld}.") (
                    lib.attrNames roles.server.machines
                  );
                };

                # Default: forward everything else to DHCP-provided resolvers
                # forward-zone = [
                #   {
                #     name = ".";
                #     forward-addr = "127.0.0.53@53"; # Forward to systemd-resolved
                #   }
                # ];
                forward-zone = [
                  {
                    name = ".";
                    forward-tls-upstream = true;
                    forward-addr = [
                      "9.9.9.9#dns.quad9.net"
                      "149.112.112.112#dns.quad9.net"
                      "1.1.1.1@853#cloudflare-dns.com"
                      "1.0.0.1@853#cloudflare-dns.com"
                      "2606:4700:4700::1111@853#cloudflare-dns.com"
                      "2606:4700:4700::1001@853#cloudflare-dns.com"
                      "8.8.8.8#dns.google"
                      "8.8.4.4#dns.google"
                      "2001:4860:4860::8888#dns.google"
                      "2001:4860:4860::8844#dns.google"
                    ];
                  }
                ];

                stub-zone = {
                  name = "${roles.server.machines.${(lib.head (lib.attrNames roles.server.machines))}.settings.tld}.";
                  stub-addr = map (
                    m: "${roles.server.machines.${m}.settings.ip}@${builtins.toString settings.dnsPort}"
                  ) (lib.attrNames roles.server.machines);
                };
              };
            };
          };
      };
  };
}
