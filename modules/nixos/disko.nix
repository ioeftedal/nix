{
  config,
  lib,
  ...
}: {
  # Installable hosts must be LUKS-encrypted, always.  The option itself lives
  # in encryption.nix (shared base, defaults false); this module flips it to
  # true and refuses to evaluate if "/" doesn't sit on a LUKS mapping.  The
  # Makefile install guards refuse hosts where it stays false.
  config = {
    hardware.fullDiskEncryption = true;

    assertions = [
      {
        assertion = lib.hasPrefix "/dev/mapper/" config.fileSystems."/".device;
        message = ''
          hosts must always install onto a LUKS-encrypted root, but "/" is on
          "${config.fileSystems."/".device}" (expected a /dev/mapper/* device).
          Removing encryption from the shared layout is not allowed.
        '';
      }
    ];

    # Shared, declarative disk layout for every LUKS-encrypted host.
    #
    # The logical disk is named `main`.  Its real block device is NOT hardcoded
    # here — disko-install injects it at install time via:
    #
    #   make install HOST=<name> DISK=/dev/disk/by-id/...
    #
    # which maps to `disko-install --flake .#<name> --disk main <DISK>`.
    # This keeps the flake portable to any drive and makes accidental-wipe much
    # harder (you must name the target device explicitly).
    #
    # Layout: 1G ESP (vfat, /boot) + rest LUKS2 "cryptroot" (ext4 /).
    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/CHANGE-ME"; # overridden by --disk at install
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            name = "ESP";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings = {
                allowDiscards = true;
                bypassWorkqueues = true;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };
    };

    # Swapfile lives on the encrypted root (encrypted by virtue of being inside
    # the LUKS volume).  Hosts can override the default size.
    swapDevices = [
      {
        device = "/swapfile";
        size = 8192;
      }
    ];
  };
}
