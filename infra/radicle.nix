{
  config,
  infra,
  lib,
  ...
}:
{
  resource.hcloud_zone_rrset =
    let
      zone = config.resource.hcloud_zone.rpqt_fr "name";
    in
    {
      radicle_a = {
        inherit zone;
        name = "radicle";
        type = "A";
        records = [ { value = infra.machines.crocus.ipv4; } ];
      };

      radicle_aaaa = {
        inherit zone;
        name = "radicle";
        type = "AAAA";
        records = [ { value = infra.machines.crocus.ipv6; } ];
      };

      radicles_srv = {
        inherit zone;
        name = "seed._radicle-node._tcp";
        type = "SRV";
        records = [ { value = "32767 32767 58776 radicle.rpqt.fr."; } ];
      };

      radicles_nid = {
        inherit zone;
        name = "seed._radicle-node._tcp";
        type = "TXT";
        records = [
          {
            value = lib.tf.ref ''provider::hcloud::txt_record("nid=z6MkuivFHDPg6Bd25v4bEWm7T7qLUYMWk1eVTE7exvum5Rvd")'';
          }
        ];
      };

      radicle_ptr = {
        inherit zone;
        name = "_radicle-node._tcp";
        type = "PTR";
        records = [ { value = "seed._radicle-node._tcp.radicle.rpqt.fr."; } ];
      };
    };
}
