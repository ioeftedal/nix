{
  description = "ioe's NixOS + nix-darwin configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    # A single entry point for every machine: NixOS or nix-darwin, chosen and
    # wired up in lib/mksystem.nix (see there).  Machines only add a hostname
    # and hardware config; everything else is shared per-OS / per-user.
    mkSystem = import ./lib/mksystem.nix {
      inherit nixpkgs inputs;
    };
  in {
    nixosConfigurations = {
      # Current AMD Ryzen + Nvidia workstation.
      desktop = mkSystem "desktop" {
        system = "x86_64-linux";
        user = "ioe";
      };
      # Laptop (no discrete GPU).
      laptop = mkSystem "laptop" {
        system = "x86_64-linux";
        user = "ioe";
      };
    };

    darwinConfigurations = {
      # macOS placeholder — grow machines/macbook.nix + users/ioe/darwin.nix.
      macbook = mkSystem "macbook" {
        system = "aarch64-darwin";
        user = "ioe";
        darwin = true;
      };
    };

    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        clang
        pkg-config
        gnumake
      ];
    };

    formatter.x86_64-linux = pkgs.alejandra;
  };
}
