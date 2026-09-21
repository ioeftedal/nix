# Laptop machine — no discrete GPU; the integrated GPU is handled by the
# generated hardware config.  Leave hardware.graphicsAccel unset so the nvidia
# module is never applied to this machine.
{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./hardware/laptop.nix
  ];

  # sway is a laptop-only environment: the desktop doesn't run a WM/compositor.
  programs.sway = {
    enable = true;
    # xwayland.enable = true;
    extraPackages = [];
  };

  networking.hostName = "laptop";

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  system.stateVersion = vars.stateVersion;
}
