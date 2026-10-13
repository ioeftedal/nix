{
  config,
  lib,
  pkgs,
  vars,
  ...
}: let
in {
  imports = [
    ./hardware/laptop.nix
  ];

  networking.hostName = "laptop";
  hardware.graphicsAccel = "nvidia";

  hardware.nvidiaDriver = "stable";
  hardware.nvidiaOpen = true;

  # sway + its browser are laptop-only: the desktop doesn't run a WM/compositor.
  programs.sway = {
    enable = true;
    # xwayland.enable = true;
    extraPackages = [];
  };

  programs.firefox.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  system.stateVersion = vars.stateVersion;
}
