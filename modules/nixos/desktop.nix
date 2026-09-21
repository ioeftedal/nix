{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  # Keyboard layout
  services.xserver.xkb = {
    layout = vars.keyLayout;
    options = vars.keyOptions;
  };

  # No xdg-desktop-portal daemon: saves ~140 MiB net (portal core, flatpak,
  # geoclue, gpsd cascade).  Firefox keeps its own GTK file dialogs; the
  # tradeoff is no Wayland screen-cast for browser video meetings.
  xdg.portal.enable = lib.mkForce false;

  # Prevent speech-dispatcher (and mbrola-voices ~645 MB) from being pulled in
  services.speechd.enable = false;

  # --- PipeWire (audio) ------------------------------------------------------
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

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
