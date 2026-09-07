{lib, ...}: {
  # Installable hosts must always be LUKS-encrypted.  This option defaults to
  # false; only hosts importing the shared disko layout (disko.nix) flip it to
  # true, and the Makefile refuses `make install` for anything that stays
  # false — so every install lands on an encrypted drive.
  options.hardware.fullDiskEncryption = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether the host's root filesystem is LUKS-encrypted.";
  };
}
