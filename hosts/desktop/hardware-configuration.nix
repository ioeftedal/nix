# Placeholder — generate the real one during install:
#   nixos-generate-config --no-filesystems --root /mnt
# then copy /mnt/etc/nixos/hardware-configuration.nix here.
# It auto-detects CPU vendor, kernel modules, etc.  Do NOT hand-write it.
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
