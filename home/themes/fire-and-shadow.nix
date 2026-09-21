# Fire & Shadow color palette (Omarchy / mattbbia), inspired by Joseph Wright.
# Single source of truth for every themed dotfile: change a value here and
# run `make rebuild` to apply it everywhere.
{
  name = "fire-and-shadow";

  wallpaper = ../../assets/wallpapers/wallpaper.jpg;

  # Core surfaces & text
  bg = "#090704"; # terminal/primary background
  panel = "#22201d"; # bar/notification surface (lighter bg)
  fg = "#DCB39B"; # primary foreground (candlelit tan)
  muted = "#605d57"; # secondary text / inactive accents
  accent = "#a4735b"; # rust accent
  border = "#302e29"; # subtle surface border (selection tone)
  active = "#f2d98b"; # focused window / verified accent (flame gold)
  cursor = "#DCB39B";
  selectionFg = "#090704";

  # ANSI 16 (normal)
  normal = {
    black = "#090704";
    red = "#b28e6b";
    green = "#dcbf87";
    yellow = "#ffeba9";
    blue = "#a4735b";
    magenta = "#d79e76";
    cyan = "#f2d98b";
    white = "#DCB39B";
  };

  # ANSI 16 (bright)
  bright = {
    black = "#605d57";
    red = "#cea275";
    green = "#fad48a";
    yellow = "#ffe996";
    blue = "#c28567";
    magenta = "#f8b07c";
    cyan = "#ffef8d";
    white = "#fcf4ea";
  };
}
