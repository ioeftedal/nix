# Creates a NixOS or nix-darwin system from a machine name.  Modeled on
# https://github.com/mitchellh/nixos-config/blob/main/lib/mksystem.nix
#
# Usage (see flake.nix):
#   nixosConfigurations.desktop = mkSystem "desktop" { system = "x86_64-linux"; user = "ioe"; };
#   darwinConfigurations.macbook = mkSystem "macbook" { system = "aarch64-darwin"; user = "ioe"; darwin = true; };
#
# A machine pulls in:
#   - machines/<name>.nix            — the machine itself (hostname, hardware)
#   - machines/hardware/*.nix        — generated/hand-maintained hardware configs
#   - users/<user>/nixos.nix         — shared NixOS system config for the user
#   - users/<user>/darwin.nix        — shared nix-darwin system config
#   - users/<user>/home-manager.nix  — the user's home-manager config
#
# Machines and OS configs are fully independent: nothing the laptop declares
# ever leaks into the desktop build and vice versa.
{
  nixpkgs,
  inputs,
}: name: {
  system ? "x86_64-linux",
  user,
  darwin ? false,
}: let
  vars = import ../variables.nix;

  # True if this is a macOS (nix-darwin) machine.
  isDarwin = darwin;

  # The config files for this machine/user.
  machineConfig = ../machines/${name}.nix;
  userOSConfig =
    ../users/${user}/${
      if isDarwin
      then "darwin"
      else "nixos"
    }.nix;
  userHMConfig = ../users/${user}/home-manager.nix;

  # NixOS vs nix-darwin functions.
  systemFunc =
    if isDarwin
    then inputs.darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;
  home-manager =
    if isDarwin
    then inputs.home-manager.darwinModules
    else inputs.home-manager.nixosModules;

  inherit (nixpkgs.lib) optionals;
in
  systemFunc {
    inherit system;

    modules =
      [
        # Allow unfree packages.
        {nixpkgs.config.allowUnfree = true;}

        machineConfig
        userOSConfig

        home-manager.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs vars;
            currentSystemName = name;
            isDarwin = isDarwin;
          };
          home-manager.users.${user} = import userHMConfig;
        }

        # Expose arguments so any module can parameterize on the machine it is
        # running on (same mechanism as mitchellh's config).
        {
          config._module.args = {
            inherit inputs vars;
            currentSystem = system;
            currentSystemName = name;
            currentSystemUser = user;
            isDarwin = isDarwin;
          };
        }
      ]
      # NixOS-only inputs/modules; nix-darwin machines skip determinate.
      ++ optionals (!isDarwin) [
        inputs.determinate.nixosModules.default
      ];
  }
