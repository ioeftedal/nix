# Desktop machine — the AMD Ryzen 5800X + Nvidia workstation this repo lives
# on.  Install with `nixos-install --flake .#desktop`.
{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./hardware/desktop.nix
  ];

  networking.hostName = "desktop";
  hardware.graphicsAccel = "nvidia";

  # Docker daemon backing Hermes' sandboxed terminal backend (all agent
  # terminal/file/code execution runs in a hardened container).
  virtualisation.docker.enable = true;

  # Ollama server (desktop-only — only machine with a discrete GPU).  Backs
  # Hermes, which talks to it fully offline over the loopback endpoint.
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;
    # GTX 1080 Ti is Pascal (compute capability 6.1); nixpkgs' default CUDA
    # arches may omit it, so build a binary that includes it explicitly.
    package = pkgs.ollama-cuda.override {
      cudaArches = [ "61" ];
    };
    loadModels = [
      "gemma4:e4b"
    ];
    environmentVariables.OLLAMA_CONTEXT_LENGTH = "65536";
  };

  # Keep ioe's hermes gateway user service alive after logout.  Hermes is
  # desktop-only: sessions, skills and cron live under ~/.hermes.
  users.users.ioe.linger = true;
  # Docker group only (merges with wheel/video from modules/nixos/users.nix)
  # so the sandboxed Hermes terminal backend can drive the daemon.
  users.users.ioe.extraGroups = ["docker"];

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];

  system.stateVersion = vars.stateVersion;
}
