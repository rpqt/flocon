{
  services.unbound = {
    settings = {
      auth-zone = [
        {
          name = "home.rpqt.fr.";
          zonefile = builtins.toFile "home.rpqt.fr.zone" ''
            $TTL 3600 ; 1 Hour
            $ORIGIN home.rpqt.fr.
            home.rpqt.fr. IN SOA ns1 admin.rpqt.fr. (
            	2025063000 ; serial
            	10800 ; refresh
            	3600 ; retry
            	604800 ; expire
            	300 ; minimum
            )

            @ 1D IN NS ns1.home.rpqt.fr.
            @ 1D IN NS ns2.home.rpqt.fr.
            @ 1D IN NS ns3.home.rpqt.fr.

            ns1 10800 IN CNAME crocus.home.rpqt.fr.
            ns2 10800 IN CNAME genepi.home.rpqt.fr.
            ns3 10800 IN CNAME verbena.home.rpqt.fr.

            crocus 10800 IN AAAA fd80:150d:17cc:2ae:6999:9380:150d:17cc
            genepi 10800 IN AAAA fd80:150d:17cc:2ae:6999:9358:3e0e:d738
            verbena 10800 IN AAAA fd80:150d:17cc:2ae:6999:9306:9a0e:c197
            haze 10800 IN AAAA fd80:150d:17cc:2ae:6999:935a:e8:b04d
          '';
        }
      ];
    };
  };
}
