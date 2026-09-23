# Hermes Agent, desktop-only (gated in home/default.nix): CLI/TUI plus the
# Signal messaging gateway.  Run as a user service so sessions, skills and cron
# live under ~/.hermes.  Signal is bridged via signal-cli in HTTP daemon mode.
{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}: {
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  programs.hermes-agent.enable = true;

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    environmentFiles = [
      osConfig.sops.secrets."hermes.env".path
    ];
    settings = {
      # Fully local/offline model via the Ollama server next door.
      # qwen3.5:9b advertises 262k native context; 64k keeps the KV cache
      # within the 1080 Ti's 11 GB (some layer offload is normal).
      model = {
        provider = "custom";
        base_url = "http://localhost:11434/v1";
        default = "gemma4:e4b";
        context_length = 65536;
      };
      platforms.signal.enabled = true;
    };
  };

  home.packages = with pkgs; [
    signal-cli
  ];

  systemd.user.services.signal-cli = {
    Unit = {
      Description = "signal-cli daemon (HTTP mode) backing the Hermes Signal gateway";
      After = [ "network-online.target" ];
    };
    Service = {
      EnvironmentFile = [ osConfig.sops.secrets."hermes.env".path ];
      ExecStart = "${pkgs.signal-cli}/bin/signal-cli --account \$SIGNAL_ACCOUNT daemon --http 127.0.0.1:8080";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.hermes-agent = {
    Unit = {
      After = [ "signal-cli.service" ];
      Wants = [ "signal-cli.service" ];
    };
  };
}
