# Home-manager entry point for user `ioe`.  The full module set lives in
# home/ (see home/default.nix), which is darwin-aware: Linux-only modules
# (sway, dunst, media helpers) are skipped on macOS via the `isDarwin` arg
# injected by lib/mksystem.nix.
{
  imports = [
    ../../home
  ];
}
