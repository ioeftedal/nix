# Active theme selection. Set `theme` to any theme defined in ./themes to
# switch palettes, then run `make rebuild`. The resolved palette is exposed to
# other home modules via `config.themePalette`.
{
  config,
  lib,
  ...
}: let
  themes = {
    osaka-jade = import ./themes/osaka-jade.nix;
    miasma = import ./themes/miasma.nix;
    nord = import ./themes/nord.nix;
    fire-and-shadow = import ./themes/fire-and-shadow.nix;
    aura = import ./themes/aura.nix;
    coffee = import ./themes/coffee.nix;
    alchemy = import ./themes/alchemy.nix;
    catppuccin-mocha = import ./themes/catppuccin-mocha.nix;
    hp = import ./themes/hp.nix;
  };
in {
  options.theme = lib.mkOption {
    type = lib.types.enum (lib.attrNames themes);
    default = "catppuccin-mocha";
    description = "Active color theme. One of: ${lib.concatStringsSep ", " (lib.attrNames themes)}.";
  };

  options.themePalette = lib.mkOption {
    type = lib.types.anything;
    internal = true;
    description = "Resolved palette attributes of the active theme.";
  };

  config.themePalette = themes.${config.theme};
}
