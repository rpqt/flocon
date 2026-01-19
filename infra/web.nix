{ config, infra, ... }:
{
  resource.hcloud_zone_rrset =
    let
      sourcehut_pages = {
        ipv4 = "46.23.81.157";
        ipv6 = "2a03:6000:1813:1337::157";
      };
      zone = config.resource.hcloud_zone.rpqt_fr "name";
    in
    {
      a = {
        inherit zone;
        name = "@";
        type = "A";
        records = [ { value = sourcehut_pages.ipv4; } ];
      };

      aaaa = {
        inherit zone;
        name = "@";
        type = "AAAA";
        records = [ { value = sourcehut_pages.ipv6; } ];
      };

      cloud_a = {
        inherit zone;
        name = "cloud";
        type = "A";
        records = [ { value = infra.machines.verbena.ipv4; } ];
      };

      cloud_aaaa = {
        inherit zone;
        name = "cloud";
        type = "AAAA";
        records = [ { value = infra.machines.verbena.ipv6; } ];
      };

      git_turifer_dev_a = {
        zone = config.resource.hcloud_zone.turifer_dev "name";
        name = "git";
        type = "A";
        records = [ { value = infra.machines.verbena.ipv4; } ];
      };

      git_turifer_dev_aaaa = {
        zone = config.resource.hcloud_zone.turifer_dev "name";
        name = "git";
        type = "AAAA";
        records = [ { value = infra.machines.verbena.ipv6; } ];
      };

      buildbot_turifer_dev_a = {
        zone = config.resource.hcloud_zone.turifer_dev "name";
        name = "buildbot";
        type = "A";
        records = [ { value = infra.machines.verbena.ipv4; } ];
      };

      buildbot_turifer_dev_aaaa = {
        zone = config.resource.hcloud_zone.turifer_dev "name";
        name = "buildbot";
        type = "AAAA";
        records = [ { value = infra.machines.verbena.ipv6; } ];
      };
    };
}
