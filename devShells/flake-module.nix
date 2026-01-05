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
          inputs'.clan-core.packages.clan-cli
          pkgs.garage
          pkgs.nil # Nix language server
          pkgs.nixfmt
          pkgs.opentofu
          pkgs.terraform-ls
          pkgs.deploy-rs
          pkgs.zsh
        ];
        shellHook = ''
          export GARAGE_RPC_SECRET=$(clan vars get crocus garage-shared/rpc_secret)
          export GARAGE_RPC_HOST=5d8249fe49264d36bc3532bd88400498bf9497b5cd4872245eb820d5d7797ed6@crocus.val:3901
        '';
      };
    };
}
