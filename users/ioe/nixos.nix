# System-level NixOS configuration shared by every Linux machine for user
# `ioe`.  Machines only add their own hardware config + hostname (see
# machines/).  Home-manager is registered centrally by lib/mksystem.nix, not
# here.
{
  imports = [
    ../../modules/nixos
  ];
}
