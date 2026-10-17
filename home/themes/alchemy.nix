# Alchemy color palette (Omarchy / nico-m-dev), a memento mori theme, MIT licensed.
# Single source of truth for every themed dotfile: change a value here and
# run `make rebuild` to apply it everywhere.
{
  name = "alchemy";

  wallpaper = ../../assets/wallpapers/wallpaper.jpg;

  # Core surfaces & text
  bg = "#0D0A07"; # terminal/primary background (near-black warm brown)
  panel = "#090705"; # bar/notification surface (dark_background)
  fg = "#D8D2C8"; # primary foreground (warm ivory)
  muted = "#6E6760"; # secondary text / inactive accents
  accent = "#C08A3E"; # aged gold accent
  border = "#1D1A16"; # subtle surface border (lighter_background, same as selection)
  active = "#C08A3E"; # focused window (aged gold, as the bar/highlight)
  cursor = "#C08A3E"; # gold cursor, matches the accent
  selectionFg = "#0D0A07"; # dark text on the light gold selection

  # ANSI 16 (normal) — 1:1 from colors.toml
  normal = {
    black = "#060403"; # darker_background
    red = "#C05A4A";
    green = "#8AA65C";
    yellow = "#D9B45C";
    blue = "#5F7FA8";
    magenta = "#9E6F8F";
    cyan = "#5E8F88";
    white = "#E6E0D6"; # light_foreground
  };

  # ANSI 16 (bright) — 1:1 from colors.toml; colors.toml has no bright black,
  # so that slot reuses the muted tone (same convention as coffee).
  bright = {
    black = "#6E6760"; # muted
    red = "#D9775F"; # bright_red
    green = "#9DBB6E"; # bright_green
    yellow = "#E4C16E"; # bright_yellow
    blue = "#7092BD"; # bright_blue
    magenta = "#B186A3"; # bright_magenta
    cyan = "#6FA39B"; # bright_cyan
    white = "#F0EBE2"; # bright_foreground
  };
}
