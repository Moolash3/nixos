# =========================================================================
#  DO NOT USE THIS FILE AS-IS.
#
#  hardware-configuration.nix is machine-specific (disk UUIDs, kernel modules,
#  filesystems). Generate the real one on the target machine with:
#
#      sudo nixos-generate-config --root /mnt        # during install
#      # or, on a running system:
#      sudo nixos-generate-config --dir .
#
#  Then replace this placeholder with the generated file. The stub below only
#  exists so the flake evaluates for inspection; it will NOT boot a real system.
# =========================================================================
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];   # or "kvm-amd"
  boot.extraModulePackages = [ ];

  # REPLACE these with your real devices/UUIDs from nixos-generate-config.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
