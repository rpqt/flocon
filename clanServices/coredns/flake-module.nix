{ ... }:
let
  module = ./default.nix;
in
{
  clan.modules = {
    "@rpqt/coredns" = module;
  };
  # perSystem =
  #   { ... }:
  #   {
  #     clan.nixosTests.coredns = {
  #       imports = [ ./tests/vm/default.nix ];

  #       clan.modules."@rpqt/coredns" = module;
  #     };
  #   };
}
