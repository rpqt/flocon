{
  nix.settings = {
    substituters = [
      "https://cache.nixos.org?priority=10"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
}
