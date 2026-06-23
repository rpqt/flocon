{ self, ... }:
{
  imports = [
    self.inputs.nixos-wsl.nixosModules.default
    {
      system.stateVersion = "26.05";
      wsl.enable = true;
      wsl.defaultUser = "rpqt";
    }
  ];
}
