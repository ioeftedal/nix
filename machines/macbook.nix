# macbook — nix-darwin placeholder.  Fill in real hardware/per-machine
# settings here (or add machines/<name>.nix per Mac) once one exists.  The
# shared darwin system config lives in users/ioe/darwin.nix.
{
  networking.hostName = "macbook";

  # stateVersion is set in the shared users/ioe/darwin.nix.
  # Set it here only if this machine needs a different one.
}
