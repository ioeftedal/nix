{
  username = "ioe";

  # GitHub no-reply identity — never a personal address.  The eduroam campus
  # identity lives inside the sops-encrypted secrets (secrets/secrets.yaml),
  # not in plaintext here.
  email = "146436657+ioeftedal@users.noreply.github.com";

  repoDir = "/home/ioe/nixos";

  timeZone = "Europe/Amsterdam";
  locale = "en_US.UTF-8";

  keyLayout = "us";
  keyOptions = "caps:ctrl";

  stateVersion = "26.05";
}
