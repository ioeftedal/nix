# Aura color palette (Omarchy / bjarneo), a pastel dark theme.
# Single source of truth for every themed dotfile: change a value here and
# run `make rebuild` to apply it everywhere.
{
  name = "aura";

  wallpaper = ../../assets/wallpapers/wallpaper.jpg;

  # Core surfaces & text
  bg = "#282a36"; # terminal/primary background
  panel = "#1e2029"; # bar/notification surface (dark_background)
  fg = "#f8f8f2"; # primary foreground
  muted = "#44475a"; # secondary text / inactive accents
  accent = "#8be9fd"; # signature ice-blue accent
  border = "#44475a"; # subtle surface border (lighter_background)
  active = "#8be9fd"; # focused window (hyprland active border)
  cursor = "#8be9fd"; # accent cursor, matches the active border
  selectionFg = "#282a36"; # dark text on the light accent selection

  # ANSI 16 (normal) — 1:1 from colors.toml
  normal = {
    black = "#14151b"; # darker_background
    red = "#ffafcc";
    green = "#8be9fd";
    yellow = "#cbc3e3";
    blue = "#8be9fd";
    magenta = "#ffc8dd";
    cyan = "#8be9fd";
    white = "#fbfbf6"; # light_foreground
  };

  # ANSI 16 (bright) — see notes on brown/bright_red below
  bright = {
    black = "#44475a"; # muted
    red = "#ffafcc"; # bright_red
    green = "#bde0fe"; # bright_green
    yellow = "#ffb86c"; # orange (colors.toml has no bright_yellow)
    blue = "#bde0fe"; # bright_blue
    magenta = "#ffc8dd"; # bright_magenta
    cyan = "#bde0fe"; # bright_cyan
    white = "#ffffff"; # bright_foreground
  };
}
