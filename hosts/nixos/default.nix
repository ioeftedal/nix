{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "nixos";
  # This machine is an Intel+Nvidia hybrid and runs the Nvidia driver.
  hardware.graphicsAccel = "nvidia";

  system.stateVersion = vars.stateVersion;

  # NOTE: the root filesystem is plain ext4 by UUID — NO LUKS full-disk
  # encryption on the running system.  The fix is a reimage using
  # hosts/luks + disko.  See LUKS-REINSTALL.md.
}
