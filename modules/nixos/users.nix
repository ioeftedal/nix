{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}: {
  users.users.${vars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"];
  };

  # --- Home Manager ----------------------------------------------------------
  home-manager = {
    # Use the system's nixpkgs rather than a separate home-manager instance
    useGlobalPkgs = true;
    useUserPackages = true;

    # Never silently destroy a file it would overwrite; keep a backup instead
    backupFileExtension = "hm-backup";

    extraSpecialArgs = {
      inherit inputs vars;
    };

    users.${vars.username} = {
      imports = [../../home];
    };
  };
}
