{ config, lib, ... }:
let
  inherit (import ./lib.nix { inherit lib; })
    mkMigadu_hcloud_zone_rrset
    ;
  rpqt_fr = mkMigadu_hcloud_zone_rrset (config.resource.hcloud_zone.rpqt_fr "name") "pgeaq3bp";

  # Prefix resource names with zone name to avoid collision
  turifer_dev = lib.mapAttrs' (name: value: lib.nameValuePair "turifer_dev_${name}" value) (
    mkMigadu_hcloud_zone_rrset (config.resource.hcloud_zone.turifer_dev "name") "k5z4lcfc"
  );
in
{
  resource.hcloud_zone_rrset = rpqt_fr // turifer_dev;
}
