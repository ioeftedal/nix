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
}: {
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

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  system.stateVersion = vars.stateVersion;
}
