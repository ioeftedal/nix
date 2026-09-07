{inputs, ...}: {
  # Keep the nixpkgs registry pinned to our flake input, otherwise the
  # determinate module redirects it to their weekly tarball.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  # Disable Determinate Nixd Sentry crash telemetry.
  environment.etc."determinate/config.json" = {
    text = builtins.toJSON {
      telemetry = {
        sentry = {
          endpoint = null;
        };
      };
    };
  };
}
