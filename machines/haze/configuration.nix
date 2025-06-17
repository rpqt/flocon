{
  self,
  ...
}:
{
  imports = [
    # inputs.disko.nixosModules.disko
    self.inputs.agenix.nixosModules.default
    ./boot.nix
    ./chat.nix
    ./firefox.nix
    ./gimp.nix
    ./gnome.nix
    ./hibernate.nix
    ./niri.nix
    ./ssh.nix
    ./steam.nix
    ./thunderbird.nix
    ./network.nix
    ./syncthing.nix
    ./topology.nix
    ./video.nix
    ../../system

    self.inputs.clan-core.clanModules.state-version
    self.inputs.clan-core.clanModules.trusted-nix-caches

    self.inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rpqt = ./home.nix;
      home-manager.extraSpecialArgs = { inherit (self) inputs; };
    }
  ];

  networking.hostName = "haze";
  clan.core.networking.targetHost = "rpqt@haze.local";

  specialisation = {
    hyprland.configuration =
      { ... }:
      {
        imports = [ ./hyprland.nix ];
        disabledModules = [ ./niri.nix ];
      };
    sway.configuration =
      { ... }:
      {
        imports = [ ./sway.nix ];
        disabledModules = [ ./niri.nix ];
      };
  };

  programs.kdeconnect.enable = true;

  # Remote builds
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        sshUser = "nixremote";
        sshKey = "/etc/ssh/ssh_host_ed25519_key";
        systems = [ "aarch64-linux" ];
        hostName = "genepi";
      }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
