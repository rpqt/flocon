{ config, ... }:
{

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
    "usb_storage"
  ];

  boot.loader = {
    generic-extlinux-compatible.enable = false;
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  boot.supportedFilesystems = [
    "vfat"
  ];
}
