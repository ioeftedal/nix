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

  networking.hostName = "laptop";

  # Disk chosen at install:  make install HOST=laptop DISK=...
  # (shared layout in modules/nixos/disko.nix)

  # No discrete GPU — leave hardware.graphicsAccel unset (null default), so
  # the nvidia module is not applied.  The generated hardware-configuration.nix
  # handles the integrated GPU.

  system.stateVersion = vars.stateVersion;

  # After first boot, enroll TPM2 for passwordless unlock:
  #   sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-id/YOUR-DISK
}
