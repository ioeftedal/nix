{
  config,
  lib,
  pkgs,
  ...
}: let
  c = config.themePalette;
in {
  home.packages = [pkgs.dunst];

  xdg.configFile."dunst/dunstrc".text = ''
    [global]
        monitor = 0
        follow = mouse
        width = 340
        height = 96
        origin = top-right
        offset = 12x56
        scale = 0
        notification_limit = 4
        padding = 10
        horizontal_padding = 12
        corner_radius = 10
        transparency = 10
        separate_color = true
        progress_bar = true
        progress_bar_height = 8
        progress_bar_frame_width = 1
        progress_bar_min_width = 160
        progress_bar_max_width = 300
        timeout = 4
        font = "JetBrains Mono 11"
        format = "<b>%s</b>\n%b"

        background = "${c.panel}"
        foreground = "${c.fg}"
        highlight = "${c.accent}"
        frame_color = "${c.border}"
        frame_width = 1

    [urgency_low]
        timeout = 3

    [urgency_critical]
        background = "${c.normal.red}"
        foreground = "${c.bg}"
        frame_color = "${c.normal.red}"
        timeout = 0
  '';
}
