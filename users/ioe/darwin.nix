# System-level nix-darwin configuration shared by every macOS machine for
# user `ioe`.  Machines only add their hostname (see machines/).  This is the
# placeholder base for the Mac fleet — grow it here as macOS-specific needs
# come up.
{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  # nix-darwin's stateVersion is an integer (unlike NixOS's "26.05" strings).
  # Bump only when upgrading the nix-darwin input.
  system.stateVersion = 7;

  # Declare the macOS user account.  `home` here is what home-manager reads
  # for `home.homeDirectory` (its common.nix derives it from
  # `users.users.<name>.home`).
  users.users.ioe = {
    home = "/Users/ioe";
    description = "ioe";
  };

  # Per-user nix-darwin options (system.defaults.*) apply to this user.
  system.primaryUser = "ioe";

  # Flakes are required for this repo to be used.
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.optimise.automatic = true;

  # A few sane macOS defaults; tweak freely per machine via its machine file.
  system.defaults.dock = {
    autohide = true;
    show-recents = false;
  };

  system.defaults.finder.AppleShowAllFiles = true;

  # Shell available to the user.
  environment.shells = [pkgs.zsh];
}
