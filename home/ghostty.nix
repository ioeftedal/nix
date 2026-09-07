{
  config,
  lib,
  pkgs,
  mkDot,
  ...
}: let
  c = config.themePalette;

  # Ghostty theme file, installed to ~/.config/ghostty/themes/${c.name} so
  # `theme = ${c.name}` in config.ghostty resolves by name.
  theme = ''
    background = ${c.bg}
    foreground = ${c.fg}
    cursor-color = ${c.cursor}
    cursor-text = #000000

    # normal colors
    palette = 0=${c.normal.black}
    palette = 1=${c.normal.red}
    palette = 2=${c.normal.green}
    palette = 3=${c.normal.yellow}
    palette = 4=${c.normal.blue}
    palette = 5=${c.normal.magenta}
    palette = 6=${c.normal.cyan}
    palette = 7=${c.normal.white}

    # bright colors
    palette = 8=${c.bright.black}
    palette = 9=${c.bright.red}
    palette = 10=${c.bright.green}
    palette = 11=${c.bright.yellow}
    palette = 12=${c.bright.blue}
    palette = 13=${c.bright.magenta}
    palette = 14=${c.bright.cyan}
    palette = 15=${c.bright.white}
  '';
in {
  home.packages = [pkgs.ghostty];

  xdg.configFile."ghostty/config.ghostty".text = ''
    theme = ${c.name}

    # Spawn an independent process per session so each one re-reads the
    # (rebuilt) config from disk and picks up a changed theme on launch.
    gtk-single-instance = false

    font-family = JetBrains Mono
    font-size = 11

    title = ""

    custom-shader = cursor.glsl

    mouse-hide-while-typing = true

    # Don't toast every config reload (theme switching reloads config often).
    app-notifications = clipboard-copy
  '';
  xdg.configFile."ghostty/themes/${c.name}".text = theme;
  xdg.configFile."ghostty/cursor.glsl".source = mkDot "ghostty/cursor.glsl";
}
