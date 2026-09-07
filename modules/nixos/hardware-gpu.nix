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

  config = lib.mkIf (config.hardware.graphicsAccel == "nvidia") {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.graphics.enable = true;

    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };

    # services.xserver is not enabled (sway/Wayland only), so the nvidia
    # kernel modules are not loaded by the X11 driver activation. Load them
    # explicitly instead.
    boot.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_drm"];
  };
}
