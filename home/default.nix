{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./apps.nix
    ./core.nix
    ./dunst.nix
    ./editors.nix
    ./fonts.nix
    ./ghostty.nix
    ./sway.nix
    ./media.nix
    ./nvim.nix
    ./waybar.nix
    ./sioyek.nix
    ./theme.nix
  ];

  home.stateVersion = vars.stateVersion;
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # `mkDot "path/relative/to/assets"` points `home.file`/`xdg.configFile` at a
  # dotfile living in this repository's `assets/` directory. Edit there and
  # run `nixos-rebuild switch` (or `make rebuild`) to apply. Static assets are
  # only used for files without theme colors.
  _module.args = {
    mkDot = rel: ../assets/${rel};
  };
}
