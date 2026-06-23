{
  perSystem =
    {
      inputs',
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          # Nix
          inputs'.clan-core.packages.clan-cli
          pkgs.flake-edit
          pkgs.nil
          pkgs.nixfmt

          # Infra
          pkgs.garage
          pkgs.opentofu
          pkgs.selfci
          pkgs.terraform-ls

          # VCS
          pkgs.difftastic
          pkgs.jjui
          pkgs.jujutsu
        ];
      };
    };
}
