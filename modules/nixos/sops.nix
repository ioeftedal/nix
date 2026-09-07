{
  config,
  lib,
  pkgs,
  ...
}: {
  sops = {
    age = {
      # Root decrypts network secrets at boot using ioe's age identity.  Root
      # bypasses the 0600 ownership on the user's key, so a single key serves
      # both interactive `sops` edits and unattended boot-time decryption.
      keyFile = "/home/ioe/.config/sops/age/keys.txt";
    };
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets."eduroam.env" = {
      mode = "0600";
      # NetworkManager's ensure-profiles service starts at multi-user.target,
      # after sops-install-secrets (sysinit.target) decrypts this to
      # /run/secrets/eduroam.env, so no extra ordering is needed.
    };
  };
}
