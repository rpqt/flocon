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
          inputs'.agenix.packages.default
          inputs'.clan-core.packages.clan-cli
          pkgs.nil # Nix language server
          pkgs.nixfmt-rfc-style
          pkgs.opentofu
          pkgs.terraform-ls
          pkgs.deploy-rs
          pkgs.zsh
        ];
        shellhook = ''
          exec zsh
        '';
      };
    };
}
