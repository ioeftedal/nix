{
  config,
  lib,
  pkgs,
  ...
}: {
  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
  };

  # SSH.  Socket-activated (only listens while a connection is being made),
  # key-based auth only, and reachable solely via the tailnet (see the
  # firewall rules in networking.nix).
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    # Don't let sshd auto-open port 22 on every interface — the only exposure
    # is the tailscale0 rule declared in networking.nix.
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Firewall rules live in networking.nix instead — they belong next to the
  # interfaces they govern, not here.
}
