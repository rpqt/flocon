{ self, ... }:
{
  imports = [
    self.homeModules.chat
    self.homeModules.common
    self.homeModules.desktop
    self.homeModules.dev
    self.homeModules.helix
    self.homeModules.mail
    self.homeModules.desktop
    self.homeModules.niri
    self.homeModules.vicinae
  ];
}
