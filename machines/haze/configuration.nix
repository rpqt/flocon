{
  self,
  ...
}:
{
  imports = [
    ./boot.nix
    ./chat.nix
    ./gimp.nix
    ./gnome.nix
    ./hibernate.nix
    ./niri.nix
    ./ssh.nix
    ./steam.nix
    ./network.nix
    ./syncthing.nix

    self.nixosModules.desktop
    self.nixosModules.nix-defaults

    self.inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rpqt = ./home.nix;
      home-manager.extraSpecialArgs = {
        inherit (self) inputs;
        inherit self;
      };
    }
  ];

  networking.hostName = "haze";
  clan.core.networking.targetHost = "rpqt@haze.local";

  networking.search = [
    "home.rpqt.fr"
  ];

  time.timeZone = "Europe/Paris";

  clan.core.deployment.requireExplicitUpdate = true;

  clan.core.settings.state-version.enable = true;

  networking.nameservers = [
    self.nixosConfigurations.genepi.config.clan.core.vars.generators.zerotier.files.zerotier-ip.value
    self.nixosConfigurations.crocus.config.clan.core.vars.generators.zerotier.files.zerotier-ip.value
  ];

  environment.systemPackages = [
    self.inputs.clan-core.packages.x86_64-linux.clan-app
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

  nixpkgs.config.allowUnfree = true;

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "fr_FR.UTF-8/UTF-8"
  ];

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.tailscale.useRoutingFeatures = "client";
}
