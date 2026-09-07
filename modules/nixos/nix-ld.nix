{...}: {
  # --- nix-ld (run unpatched binaries) -------------------------------------
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [ ... ];   # add missing libs here
  };
}
