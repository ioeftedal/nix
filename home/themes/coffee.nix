# Coffee color palette (Omarchy / megabyte0x), a dark roast theme, MIT licensed.
# Single source of truth for every themed dotfile: change a value here and
# run `make rebuild` to apply it everywhere.
{
  name = "coffee";

  wallpaper = ../../assets/wallpapers/wallpaper.jpg;

  # Core surfaces & text
  bg = "#1d150f"; # terminal/primary background (espresso)
  panel = "#160f0a"; # bar/notification surface (dark_background)
  fg = "#f0e2d0"; # primary foreground (latte cream)
  muted = "#8f7a67"; # secondary text / inactive accents
  accent = "#e0a15c"; # caramel accent
  border = "#2d2118"; # subtle surface border (lighter_background)
  active = "#e0a15c"; # focused window (caramel, as the bar/highlight)
  cursor = "#e0a15c"; # caramel cursor, matches the accent
  selectionFg = "#1d150f"; # dark text on the light caramel selection

  # ANSI 16 (normal) — 1:1 from colors.toml
  normal = {
    black = "#0e0806"; # darker_background
    red = "#d78a6f"; # cacao red
    green = "#cdb878";
    yellow = "#ffda92";
    blue = "#cf90a2";
    magenta = "#ec8f89";
    cyan = "#e8c07f";
    white = "#d9c7b3"; # light_foreground
  };

  # ANSI 16 (bright) — 1:1 from colors.toml; colors.toml has no bright black,
  # so that slot reuses the muted taupe (same convention as fire-and-shadow).
  bright = {
    black = "#8f7a67"; # muted
    red = "#e8a086"; # bright_red
    green = "#e2cd8a"; # bright_green
    yellow = "#ffe0a0"; # bright_yellow
    blue = "#e0a3b3"; # bright_blue
    magenta = "#ffa39a"; # bright_magenta
    cyan = "#ffe98f"; # bright_cyan
    white = "#fff3ea"; # bright_foreground
  };
}
