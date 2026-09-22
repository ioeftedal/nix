{
  config,
  lib,
  pkgs,
  vars,
  currentSystemName,
  isDarwin ? false,
  ...
}: let
  # sway + its helpers (dunst, media/osd, sioyek) are laptop-only: the desktop
  # is a headless-ish workstation, macOS never runs sway.  Everything else is
  # shared across all machines.
  isLaptop = currentSystemName == "laptop";
in {
  imports =
    [
      ./apps.nix
      ./core.nix
      ./editors.nix
      ./fonts.nix
      ./ghostty.nix
      ./nvim.nix
      ./theme.nix
    ]
    ++ lib.optionals (isLaptop && !isDarwin) [
      ./dunst.nix
      ./media.nix
      ./sioyek.nix
      ./sway.nix
    ]
    ++ lib.optionals (currentSystemName == "desktop") [
      ./hermes.nix
    ];

  home.stateVersion = vars.stateVersion;
  home.username = vars.username;
  # home.homeDirectory is derived by home-manager from the OS user's
  # `users.users.<name>.home` (declared in modules/nixos/users.nix and
  # users/ioe/darwin.nix) — don't set it here.

  # `mkDot "path/relative/to/assets"` points `home.file`/`xdg.configFile` at a
  # dotfile living in this repository's `assets/` directory. Edit there and
  # run `make rebuild` to apply. Static assets are only used for files without
  # theme colors.
  _module.args = {
    mkDot = rel: ../assets/${rel};
    inherit isDarwin;
  };
}
