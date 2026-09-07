# Nord color palette (arctic / north), canonical nordtheme.com.
# Single source of truth for every themed dotfile: change a value here and
# run `make rebuild` to apply it everywhere.
{
  name = "nord";

  wallpaper = "/home/ioe/Pictures/wallpapers/nord.jpg";

  # Core surfaces & text
  bg = "#2E3440"; # terminal/primary background (nord0)
  panel = "#3B4252"; # bar/notification surface (nord1)
  fg = "#D8DEE9"; # primary foreground (nord4)
  muted = "#81A1C1"; # secondary text / inactive accents (nord9)
  accent = "#88C0D0"; # ice accent (nord8)
  border = "#4C566A"; # subtle inactive-border surface border (nord3)
  active = "#8FBCBB"; # focused window / verified accent (nord7)
  cursor = "#D8DEE9";
  selectionFg = "#2E3440";

  # ANSI 16 (normal) — canonical Nord slots
  normal = {
    black = "#3B4252";
    red = "#BF616A";
    green = "#A3BE8C";
    yellow = "#EBCB8B";
    blue = "#81A1C1";
    magenta = "#B48EAD";
    cyan = "#88C0D0";
    white = "#E5E9F0";
  };

  # ANSI 16 (bright)
  bright = {
    black = "#4C566A";
    red = "#D08770";
    green = "#A3BE8C";
    yellow = "#EBCB8B";
    blue = "#81A1C1";
    magenta = "#B48EAD";
    cyan = "#8FBCBB";
    white = "#ECEFF4";
  };
}
