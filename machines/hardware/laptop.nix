# Laptop hardware configuration.  This is a placeholder so the config
# evaluates; replace it with real output from the install machine:
#   nixos-generate-config --root /mnt
# then copy /mnt/etc/nixos/hardware-configuration.nix here.  It auto-detects
# CPU vendor, kernel modules, filesystems, etc.  Do NOT hand-write it.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Placeholder layout so the system builds.  Label the disks at install time
  # (`mkfs.ext4 -L nixos`, `mkfs.vfat -n boot`), or regenerate this file.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
