# Laptop machine — Lenovo 83KY: Intel iGPU (which drives the internal panel and
# the USB-C/Thunderbolt outputs) plus an NVIDIA RTX 5060 Laptop dGPU.  The HDMI
# port is wired directly to the dGPU, so the nvidia kernel driver is mandatory
# here; the iGPU alone cannot drive HDMI.
{
  config,
  lib,
  pkgs,
  vars,
  ...
}: let
  # pkgs.factorio defaults to the paid "alpha" release, whose tarball is only
  # downloadable with a Factorio account token (needsAuth: true in nixpkgs'
  # versions.json).  The "demo" release is published publicly, so it needs no
  # credentials.  Capped playtime, and its saves are not compatible with the
  # full game.
  factorio = pkgs.factorio.override { releaseType = "demo"; };
in {
  imports = [
    ./hardware/laptop.nix
  ];

  networking.hostName = "laptop";
  hardware.graphicsAccel = "nvidia";

  # 580 is the last branch that supports the desktop's Pascal GPU, so the
  # shared default is wrong for this machine.  The RTX 5060 is Blackwell and
  # wants a current driver; 595 is the current production branch.
  hardware.nvidiaDriver = "stable";

  # Mandatory here, and exactly why: NVIDIA's proprietary module refuses to
  # initialise on Blackwell consumer parts, so nvidia_drm never registers a KMS
  # device and the HDMI port — which is wired to this dGPU — stays dead.
  hardware.nvidiaOpen = true;

  # sway + its browser are laptop-only: the desktop doesn't run a WM/compositor.
  programs.sway = {
    enable = true;
    # xwayland.enable = true;
    extraPackages = [];
  };

  programs.firefox.enable = true;

  environment.systemPackages = [ factorio ];

  # Hold on to the tarball so Nix never re-downloads it after a GC.
  system.extraDependencies = [ factorio.src ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  system.stateVersion = vars.stateVersion;
}
