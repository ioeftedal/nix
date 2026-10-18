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
  #
  # Accelerated through Vulkan, not CUDA.  The GTX 1080 Ti is Pascal (compute
  # capability 6.1) and nixpkgs ships CUDA 13, which dropped every pre-Turing
  # target — `nvcc` fails with "Unsupported gpu architecture 'compute_61'", so
  # no `ollama-cuda` build can target this card.  Pascal has no such cliff in
  # Vulkan: the 580 driver still supports it, so ggml's Vulkan compute
  # backend runs here.
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;
    package = pkgs.ollama-vulkan;
    loadModels = [
      "gemma4:e4b"
    ];
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "65536";
      # The package is meant to ship a wrapper that sets this, but nixpkgs only
      # puts makeBinaryWrapper in nativeBuildInputs for the rocm/cuda variants,
      # so for ollama-vulkan the wrapProgram call is a silent no-op and the
      # binary lands unwrapped.  Set it here instead.
      OLLAMA_VULKAN = "1";
      # The Vulkan ICD ships inside the NVIDIA driver package, and its
      # library_path is an absolute store path.  Hand the loader that path
      # directly so the server finds the GPU regardless of what the system
      # profile happens to link into /run/current-system/sw/share/vulkan.
      VK_DRIVER_FILES = "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json";
    };
  };

  # Amp headless runner: one runner serving every checkout under
  # ~/repositories/github.com.  Repositories are listed explicitly (not globbed
  # at start) so a runner only ever serves what it is meant to, and so adding a
  # checkout is a config change rather than a silent broadening of what
  # ampcode.com can start threads in.
  services.amp-runners = {
    enable = true;
    user = vars.username;

    runners.ioe.repos = [
      "eik-lab/patronus-turret-software"
      "epicgames/raddebugger"
      "ioeftedal/bipbop"
      "ioeftedal/cs-app"
      "ioeftedal/hedwig"
      "ioeftedal/kalman-cpp"
      "ioeftedal/leetcode-rust"
      "ioeftedal/me"
      "ioeftedal/multiplayer-server-test"
      "ioeftedal/pareidolia"
      "ioeftedal/pong-cpp"
      "ioeftedal/profiling"
      "ioeftedal/space_invaders"
      "ioeftedal/space-invaders-cpp"
      "ioeftedal/STAT351"
      "ioeftedal/tasyper"
      "ioeftedal/test-jujutsu"
      "ioeftedal/udp_gstreamer"
      "ioeftedal/zauron"
    ];
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
