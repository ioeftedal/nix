{
  config,
  lib,
  ...
}: {
  # Per-device capability option.  Devices set this in their host default.nix
  # to opt into vendor hardware modules.  Left null (the default) for devices
  # with only an integrated GPU.
  options.hardware.graphicsAccel = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum ["nvidia"]);
    default = null;
    description = "GPU acceleration variant for this device";
  };

  options.hardware.nvidiaDriver = lib.mkOption {
    type = lib.types.str;
    default = "legacy_580";
    description = ''
      Which branch of `boot.kernelPackages.nvidiaPackages` the NVIDIA kernel
      driver is taken from.  This is per-host because the two machines support
      different generations of hardware: the desktop's GTX 1080 Ti is Pascal,
      which NVIDIA dropped support for after the 580 series, so it stays pinned
      there; the laptop's RTX 5060 is Blackwell and needs a current branch.
    '';
  };

  options.hardware.nvidiaOpen = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Whether to use NVIDIA's open kernel modules instead of the proprietary
      ones.  Per-host, because the requirement runs in both directions: NVIDIA's
      open modules are mandatory on Blackwell consumer parts (RTX 50-series),
      while Pascal is only supported by the proprietary module in this driver
      series.  Enabling this on an unsupported GPU leaves nvidia_drm with no KMS
      device at all, and the machine loses every output wired to that GPU.
    '';
  };

  config = lib.mkIf (config.hardware.graphicsAccel == "nvidia") {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.graphics.enable = true;

    hardware.nvidia = {
      package = builtins.getAttr config.hardware.nvidiaDriver
        config.boot.kernelPackages.nvidiaPackages;
      # nixpkgs requires GSP firmware to stay enabled for the open modules.
      open = config.hardware.nvidiaOpen;
      modesetting.enable = true;
      # Keeps the dGPU out of D3cold so hot-plugged outputs stay live across
      # suspend.  Fine-grained (RTD3) power management is deliberately not
      # enabled: it would additionally require
      # hardware.nvidia.prime.offload.enable, and it permits runtime power-down
      # of the very GPU driving an external display.
      powerManagement.enable = true;
    };

    # services.xserver is not enabled (sway/Wayland only), so the nvidia
    # kernel modules are not loaded by the X11 driver activation. Load them
    # explicitly instead.
    boot.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_drm"];
  };
}
