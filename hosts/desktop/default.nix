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
    ./disko.nix
    ../../modules/nixos
  ];

  networking.hostName = "desktop";
  hardware.graphicsAccel = "nvidia";

  system.stateVersion = vars.stateVersion;

  # Swapfile on the encrypted ext4 root — encrypted by virtue of living
  # inside the LUKS volume.
  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];

  # After first boot, enroll TPM2 for passwordless unlock:
  #   sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-id/YOUR-DISK
}
