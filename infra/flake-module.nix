{
  flake.infra =
    let
      tf_outputs = builtins.fromJSON (builtins.readFile ../infra/outputs.json);
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
        };
      };
    };
}
