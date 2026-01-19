{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      terranix.terranixConfigurations.infra = {
        terraformWrapper.package = pkgs.opentofu.withPlugins (p: [
          p.hashicorp_external
          p.hetznercloud_hcloud
        ]);

        extraArgs = { inherit (self) infra; };
        modules = [
          ./base.nix
          ./dns.nix
          ./mail.nix
          ./radicle.nix
          ./web.nix
        ];
      };
    };

  flake.infra =
    let
      tf_outputs = builtins.fromJSON (builtins.readFile ./outputs.json);
    in
    {
      machines = {
        verbena = {
          ipv4 = tf_outputs.verbena_ipv4.value;
          ipv6 = tf_outputs.verbena_ipv6.value;
          gateway6 = tf_outputs.verbena_gateway6.value;
        };
        crocus = {
          ipv4 = tf_outputs.crocus_ipv4.value;
          ipv6 = "2a01:4f8:1c1e:e415::1";
        };
      };
    };
}
