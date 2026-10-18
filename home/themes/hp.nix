# Wizarding World / Harry Potter color palette, "Enchanted Realms".
# Authored as a Neovim Lua colorscheme: 13 named colors, no ANSI 16. The named
# colors are carried over verbatim; the ANSI slots are derived from them (see
# the notes on `normal`/`bright` below).
# Single source of truth for every themed dotfile: change a value here and
# run `make rebuild` to apply it everywhere.
{
  name = "hp";

  wallpaper = ../../assets/wallpapers/wallpaper.jpg;

  # Core surfaces & text — all straight from the Lua palette
  bg = "#100F18"; # terminal/primary background
  panel = "#1B1825"; # bar/notification surface, NormalFloat/CursorLine
  fg = "#D8D1E2"; # primary foreground
  muted = "#9188AD"; # secondary text / inactive accents (Comment, LineNr)
  border = "#393047"; # subtle surface border (WinSeparator)
  accent = "#E8C878"; # gold — the scheme's signature accent
  active = "#C5A5F5"; # focused window (violet; the Lua defines no focus color)
  cursor = "#E8C878"; # gold, matching the accent
  selectionFg = "#100F18"; # dark text on the light gold selection

  # ANSI 16 (normal) — derived: the Lua palette has 7 accents and one dark
  # surface, which map onto the 8 normal slots by meaning:
  # red=PreProc, yellow=gold, green=String, cyan=teal, blue=Function,
  # magenta=violet, white=white, black=surface (Visual).
  normal = {
    black = "#292437"; # surface
    red = "#E59AA6";
    green = "#A8DDA5";
    yellow = "#E8C878"; # gold
    blue = "#9BD9F5";
    magenta = "#C5A5F5"; # violet
    cyan = "#86DDD1"; # teal
    white = "#F7F0FC";
  };

  # ANSI 16 (bright) — the Lua palette defines no bright variants, so the
  # accents repeat their normal values (same convention as miasma) and only
  # black steps up the surface ladder, surface -> border (same as nord).
  bright = {
    black = "#393047"; # border
    red = "#E59AA6";
    green = "#A8DDA5";
    yellow = "#E8C878"; # gold
    blue = "#9BD9F5";
    magenta = "#C5A5F5"; # violet
    cyan = "#86DDD1"; # teal
    white = "#F7F0FC";
  };
}
