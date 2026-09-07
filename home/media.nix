{
  config,
  lib,
  pkgs,
  ...
}: {
  # swayosd provides the OSD overlay (swayosd-server) plus the client used by
  # the media-key binds in the sway config (see sway.nix). Volume/brightness/
  # mute are bound directly to `swayosd-client`, so no shell wrappers are
  # needed.
  home.packages = with pkgs; [
    swayosd
    playerctl
  ];
}
