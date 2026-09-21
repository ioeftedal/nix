{
  config,
  vars,
  ...
}: {
  # hostname is set per machine in machines/<name>.nix

  # --- Firewall --------------------------------------------------------------
  networking.firewall = {
    enable = true;

    # Tailscale: open UDP 41641 so peers can establish direct (non-relayed)
    # WireGuard tunnels.  Connections still work via DERP when this port is
    # blocked, but direct paths are lower-latency.
    allowedUDPPorts = [41641];

    # SSH is reachable only through the tailnet — never over the LAN.
    interfaces.tailscale0.allowedTCPPorts = [22];
  };

  # --- NetworkManager --------------------------------------------------------
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles.eduroam = {
    connection = {
      id = "eduroam";
      type = "wifi";
    };

    wifi = {
      mode = "infrastructure";
      ssid = "eduroam";
    };

    wifi-security = {
      key-mgmt = "wpa-eap";
    };

    "802-1x" = {
      eap = "peap";
      identity = vars.email;
      password = "$EDUROAM_PASSWORD";
      phase2-auth = "mschapv2";

      # NOTE: campus RADIUS servers widely deploy legacy TLS configs; this
      # disables certificate verification and lowers the OpenSSL security
      # level for the 802-1x handshake only (not for HTTPS or other traffic).
      # Ideal fix: push your campus IT to deploy proper certificates.
      system-ca-certs = false;
      openssl-ciphers = "DEFAULT:@SECLEVEL=0";
    };

    ipv4.method = "auto";
    ipv6.method = "auto";
  };

  # --- Secrets ----------------------------------------------------------------
  # No secret management in this repo anymore (sops-nix was removed).  The
  # eduroam profile below needs the password exported into NetworkManager's
  # environment; without a secret provider the profile won't connect.  Either
  # configure eduroam manually (nmcli GUI) or reintroduce a secret backend
  # (e.g. sops-nix) if you want this declarative again.

  # --- Tailscale mesh VPN ----------------------------------------------------
  services.tailscale.enable = true;

  # SSH identity is per-machine: each node enables Tailscale SSH once with
  # `sudo tailscale up --ssh`, which keeps node-scoped host keys and
  # authenticates by tailnet identity — no shared sshd keys anywhere.
  # Declarative-only via manual `tailscale up --ssh` after first boot.
}
