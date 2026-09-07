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

  networking.hostName = "luks";
  hardware.graphicsAccel = "nvidia";

  # Disk for this host is chosen at install time:
  #   make install HOST=luks DISK=/dev/disk/by-id/...
  # Layout comes from the shared modules/nixos/disko.nix.

  system.stateVersion = vars.stateVersion;

  # After first boot, enroll TPM2 for passwordless unlock:
  #   sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-id/YOUR-DISK
  # Falls back to a console passphrase prompt when no TPM key is enrolled.
}
