{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  programs.sway = {
    enable = true;
    xwayland.enable = true;
    extraPackages = [];
  };

  # Keyboard layout
  services.xserver.xkb = {
    layout = vars.keyLayout;
    options = vars.keyOptions;
  };

  # Browser
  programs.firefox.enable = true;

  # Prevent speech-dispatcher (and mbrola-voices ~645 MB) from being pulled in
  services.speechd.enable = false;

  # --- PipeWire (audio) ------------------------------------------------------
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.extraConfig."10-enable-usb-audio" = {
      "monitor.alsa.rules" = [
        {
          matches = [{"device.bus" = "usb";}];
          actions = {
            "update-props" = {
              "node.pause-on-idle" = false;
              "session.suspend-timeout-seconds" = 0;
              "priority.driver" = 1500;
              "priority.session" = 1500;
            };
          };
        }
      ];
    };
  };
}
