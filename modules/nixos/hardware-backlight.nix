{
  config,
  lib,
  pkgs,
  ...
}: {
  # Let the `video` group adjust screen backlight through /sys/class/backlight
  # instead of needing root.  brightnessctl runs as an unprivileged user, so
  # without this rule brightness changes are rejected.
  services.udev.extraRules = ''
    SUBSYSTEM=="backlight", ACTION=="add", \
      RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", \
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';
}
