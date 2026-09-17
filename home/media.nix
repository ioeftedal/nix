{
  config,
  lib,
  pkgs,
  ...
}: {
  # OSD is handled by the minimal bin/osd script (see sway.nix): volume/mute
  # go through wpctl (PipeWire), brightness through brightnessctl, and player
  # controls through playerctl, all rendering as dunst notifications.
  home.packages = with pkgs; [
    brightnessctl
    playerctl
  ];
}
