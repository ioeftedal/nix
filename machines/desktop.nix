# Desktop machine — the AMD Ryzen 5800X + Nvidia workstation this repo lives
# on.  Install with `nixos-install --flake .#desktop`.
{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./hardware/desktop.nix
  ];

  networking.hostName = "desktop";
  hardware.graphicsAccel = "nvidia";

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];

  system.stateVersion = vars.stateVersion;
}
