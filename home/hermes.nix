# Hermes Agent, desktop-only (gated in home/default.nix): CLI/TUI plus the
# gateway.  Run as a user service so sessions, skills and cron live under
# ~/.hermes.
#
# Hardening: all terminal/file/code execution runs inside a persistent
# hardened Docker sandbox container.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  programs.hermes-agent.enable = true;

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    settings = {
      # Fully local/offline model via the Ollama server next door.
      # qwen3.5:9b advertises 262k native context; 64k keeps the KV cache
      # within the 1080 Ti's 11 GB (some layer offload is normal).
      model = {
        provider = "custom";
        base_url = "http://localhost:11434/v1";
        default = "gemma4:e4b";
        # context_length = 65536;
      };

      # Sandbox every terminal/file/execute_code call in one long-lived,
      # hardened Docker container (read-only rootfs, dropped caps,
      # no-new-privs, PID/namespace isolation).  /workspace persists across
      # sessions.  Needs the docker CLI in the unit PATH — provided below via
      # extraPackages.
      terminal = {
        backend = "docker";
        docker_image = "nikolaik/python-nodejs:python3.11-nodejs20";
        container_persistent = true;
      };
    };

    # docker CLI must be on the hermes gateway unit PATH to run the sandbox
    # backend; the module's extraPackages feeds the unit PATH.
    extraPackages = [ pkgs.docker ];
  };
}
