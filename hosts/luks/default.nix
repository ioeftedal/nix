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

  networking.hostName = "luks";
  hardware.graphicsAccel = "nvidia";

  system.stateVersion = vars.stateVersion;

  # Swapfile on the encrypted ext4 root — encrypted by virtue of living
  # inside the LUKS volume.  No separate encrypted swap partition needed.
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  # After first boot, enroll TPM2 for passwordless unlock:
  #   sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-id/YOUR-DISK
  # Falls back to a console passphrase prompt when no TPM key is enrolled.
}
