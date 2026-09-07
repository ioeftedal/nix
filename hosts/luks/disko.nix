{
  disko.devices = {
    disk = {
      nvme1n1 = {
        type = "disk";
        device = "/dev/disk/by-id/REDACTED-NVME-BY-ID";
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
