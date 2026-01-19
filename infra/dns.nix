{ config, ... }:
{
  resource.hcloud_zone.rpqt_fr = {
    name = "rpqt.fr";
    mode = "primary";
  };

  resource.hcloud_zone.turifer_dev = {
    name = "turifer.dev";
    mode = "primary";
  };

  output.rpqt_fr_zone_name = {
    value = config.resource.hcloud_zone.rpqt_fr "name";
  };

  output.turifer_dev_zone_name = {
    value = config.resource.hcloud_zone.turifer_dev "name";
  };
}
