{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  # --- Nix settings -------------------------------------------------------
  nix = {
    settings = {
      # This tree is intentionally not a git repo, so every build would print
      # a "git tree is dirty" warning.  Suppress it; hash-checking still counts
      # on the flake lock, and `no-gc-root`/`result` handling is unchanged.
      warn-dirty = false;
    };
  };

  # --- Boot ----------------------------------------------------------------
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # --- System-wide package policy ------------------------------------------
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "1password-gui"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-vaapi-driver"
      "nvidia-persistenced"
    ];

  # --- Locale / time --------------------------------------------------------
  time.timeZone = vars.timeZone;
  i18n.defaultLocale = vars.locale;
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8"];

  # --- State ----------------------------------------------------------------
  system.stateVersion = vars.stateVersion;
}
