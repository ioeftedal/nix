{
  config,
  inputs,
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

  # Helium (ungoogled-chromium fork, upstream prebuilt tarball).  Pulled in as
  # an overlay so it resolves as `pkgs.helium` in both the system and
  # home-manager (which shares global pkgs) instead of a pinned package path.
  nixpkgs.overlays = [
    inputs.helium.overlays.default
  ];

  environment.systemPackages = [
    pkgs.helium
  ];

  programs.firefox.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  system.stateVersion = vars.stateVersion;
}
