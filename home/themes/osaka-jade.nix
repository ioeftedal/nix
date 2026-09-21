# Osaka Jade color palette (Omarchy / Justikun).
# Single source of truth for every themed dotfile: change a value here and
# run `make rebuild` to apply it everywhere.
{
  name = "osaka-jade";

  wallpaper = ../../assets/wallpapers/wallpaper.jpg;

  # Core surfaces & text
  bg = "#111c18"; # terminal/primary background
  panel = "#11221C"; # bar/notification surface (mako background)
  fg = "#C1C497"; # primary foreground
  muted = "#A7AC84"; # secondary text / inactive accents (hyprlock outer)
  accent = "#509475"; # jade accent
  border = "#214237"; # subtle surface border (mako border)
  active = "#71CEAD"; # focused window / verified accent (hyprland active)
  cursor = "#D7C995";
  selectionFg = "#111C18";

  # ANSI 16 (normal)
  normal = {
    black = "#23372B";
    red = "#FF5345";
    green = "#549e6a";
    yellow = "#459451";
    blue = "#509475";
    magenta = "#D2689C";
    cyan = "#2DD5B7";
    white = "#F6F5DD";
  };

  # ANSI 16 (bright)
  bright = {
    black = "#53685B";
    red = "#db9f9c";
    green = "#63b07a";
    yellow = "#E5C736";
    blue = "#ACD4CF";
    magenta = "#75bbb3";
    cyan = "#8CD3CB";
    white = "#9eebb3";
  };
}
