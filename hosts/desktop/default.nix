{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/disko.nix
    ../../modules/nixos
  ];

  networking.hostName = "desktop";
  hardware.graphicsAccel = "nvidia";

  # Disk chosen at install:  make install HOST=desktop DISK=...
  # (shared layout in modules/nixos/disko.nix)

  # Desktop: more swap than the shared 8G default.
  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];

  system.stateVersion = vars.stateVersion;

  # After first boot, enroll TPM2 for passwordless unlock:
  #   sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-id/YOUR-DISK
}
