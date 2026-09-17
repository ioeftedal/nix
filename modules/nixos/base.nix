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
      # Hardlink-deduplicate identical files across store paths.
      auto-optimise-store = true;
    };
    optimise.automatic = true;
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

  # --- Docs ------------------------------------------------------------------
  # Don't build the auto-generated NixOS/determinate manuals + man pages.
  documentation.enable = false;

  # --- Fonts ------------------------------------------------------------------
  # Default fallback sets not needed: keep only Latin (dejavu/liberation),
  # CJK (noto-cjk-sans) and emoji; drop unifont, cjk-serif, freefont, gyre.
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      dejavu_fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  # --- Firmware (minimal) ----------------------------------------------------
  # Only the firmware this machine actually loads: MediaTek MT7925 wifi
  # (mediatek), Intel i915 GPU + Intel BT (intel), SOF audio (own pkg).
  # Filtering linux-firmware (837 MiB) + legacy sets (zd1211, ipw2200, rtl*,
  # alsa, libreelec-dvb) saves ~0.7 GiB.  Nvidia GSP + intel-npu firmware are
  # added by their own modules and are unaffected by this override.
  hardware.enableRedistributableFirmware = lib.mkForce false;
  hardware.wirelessRegulatoryDatabase = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.firmware = [
    (
      pkgs.runCommand "linux-firmware-minimal" {}
        ''
          mkdir -p $out/lib/firmware
          for d in intel i915 mediatek; do
            cp -rL "${pkgs.linux-firmware}/lib/firmware/$d" "$out/lib/firmware/"
          done
        ''
    )
    pkgs.sof-firmware
  ];
}
