# Miasma color palette (Omarchy / OldJobobo), canonical ANSI by xero.
# Single source of truth for every themed dotfile: change a value here and
# run `make rebuild` to apply it everywhere.
{
  name = "miasma";

  wallpaper = ../../assets/wallpapers/wallpaper.jpg;

  # Core surfaces & text
  bg = "#222222"; # terminal/primary background
  panel = "#1c1c1c"; # bar/notification surface (Quattro bar/popup bg)
  fg = "#c2c2b0"; # primary foreground (pale linen)
  muted = "#8a8a7e"; # secondary text / inactive accents
  accent = "#78824b"; # olive accent
  border = "#43492a"; # subtle inactive-border surface border
  active = "#c9a554"; # focused window / verified accent (gold)
  cursor = "#d7c483";
  selectionFg = "#c2c2b0";

  # ANSI 16 (normal) — canonical Miasma slots
  normal = {
    black = "#222222";
    red = "#685742";
    green = "#5f875f";
    yellow = "#b36d43";
    blue = "#78824b";
    magenta = "#bb7744";
    cyan = "#c9a554";
    white = "#c2c2b0";
  };

  # ANSI 16 (bright) — Miasma intentionally repeats its normal accents here
  bright = {
    black = "#666666";
    red = "#685742";
    green = "#5f875f";
    yellow = "#b36d43";
    blue = "#78824b";
    magenta = "#bb7744";
    cyan = "#c9a554";
    white = "#d7c483";
  };
}
