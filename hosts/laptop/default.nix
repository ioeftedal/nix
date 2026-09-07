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

  networking.hostName = "laptop";

  # No discrete GPU — leave hardware.graphicsAccel unset (null default), so
  # the nvidia module is not applied.  The generated hardware-configuration.nix
  # handles the integrated GPU.

  system.stateVersion = vars.stateVersion;

  # Swapfile on the encrypted ext4 root — encrypted by virtue of living
  # inside the LUKS volume.
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  # After first boot, enroll TPM2 for passwordless unlock:
  #   sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-id/YOUR-DISK
}
