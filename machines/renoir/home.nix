{ self, ... }:
{
  imports = [
    self.homeModules.common
    self.homeModules.dev
    self.homeModules.helix
  ];
}
