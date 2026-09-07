{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        # CHANGE-ME: set to this machine's disk before install:
        #   lsblk -o NAME,SIZE,MODEL
        #   ls /dev/disk/by-id/
        device = "/dev/disk/by-id/CHANGE-ME";
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
    };
  };
}
