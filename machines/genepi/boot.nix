{ config, ... }:
{

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
    "usb_storage"
  ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  boot.supportedFilesystems = [
    "btrfs"
    "vfat"
  ];
}
