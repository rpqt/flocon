{
  self,
  ...
}:
{
  imports = [
    ./boot.nix
    ./chat.nix
    ./firefox.nix
    ./gimp.nix
    ./gnome.nix
    ./hibernate.nix
    ./hyprland.nix
    ./niri.nix
    ./ssh.nix
    ./steam.nix
    ./thunderbird.nix
    ./network.nix
    ./syncthing.nix
    ./topology.nix
    ./video.nix
    ../../system

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

  networking.search = [
    "home.rpqt.fr"
  ];

  time.timeZone = "Europe/Paris";
  clan.deployment.requireExplicitUpdate = true;

  clan.core.settings.state-version.enable = true;

  networking.nameservers = [
    self.nixosConfigurations.genepi.config.clan.core.vars.generators.zerotier.files.zerotier-ip.value
    self.nixosConfigurations.crocus.config.clan.core.vars.generators.zerotier.files.zerotier-ip.value
  ];

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

  services.tailscale.useRoutingFeatures = "client";
}
