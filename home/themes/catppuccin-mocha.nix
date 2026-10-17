# Catppuccin Mocha color palette (catppuccin.com), the flagship dark flavor.
# Values are taken verbatim from the canonical palette definition, including
# the official ANSI 16 `ansiColors` block, so this tracks upstream exactly.
# Single source of truth for every themed dotfile: change a value here and
# run `make rebuild` to apply it everywhere.
{
  name = "catppuccin-mocha";

  wallpaper = ../../assets/wallpapers/wallpaper.jpg;

  # Core surfaces & text
  bg = "#1e1e2e"; # terminal/primary background (Base)
  panel = "#181825"; # bar/notification surface (Mantle)
  fg = "#cdd6f4"; # primary foreground (Text)
  muted = "#9399b2"; # secondary text / inactive accents (Overlay 2)
  accent = "#cba6f7"; # Mauve — Catppuccin's signature accent
  border = "#313244"; # subtle surface border (Surface 0)
  active = "#89b4fa"; # focused window (Blue, kept distinct from the accent)
  cursor = "#f5e0dc"; # Rosewater, as in the official terminal themes
  selectionFg = "#1e1e2e"; # dark text on the light Mauve selection

  # ANSI 16 (normal) — official Catppuccin ansiColors, codes 0-7
  normal = {
    black = "#45475a"; # Surface 1
    red = "#f38ba8";
    green = "#a6e3a1";
    yellow = "#f9e2af";
    blue = "#89b4fa";
    magenta = "#f5c2e7"; # Pink
    cyan = "#94e2d5"; # Teal
    white = "#a6adc8"; # Subtext 0
  };

  # ANSI 16 (bright) — official Catppuccin ansiColors, codes 8-15
  bright = {
    black = "#585b70"; # Surface 2
    red = "#f37799";
    green = "#89d88b";
    yellow = "#ebd391";
    blue = "#74a8fc";
    magenta = "#f2aede";
    cyan = "#6bd7ca";
    white = "#bac2de"; # Subtext 1
  };
}
