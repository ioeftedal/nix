{
  description = "ioe's NixOS configuration";

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    vars = import ./variables.nix;
    pkgs = nixpkgs.legacyPackages.${system};

    # Modules every host pulls in; hosts only add their own directory.
    sharedModules = [
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      inputs.determinate.nixosModules.default
      inputs.sops-nix.nixosModules.sops
    ];

    mkHost = hostDir:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs vars;
        };

        modules = [hostDir] ++ sharedModules;
      };
  in {
    nixosConfigurations = {
      # Current unencrypted host — remove after reimage to LUKS.
      nixos = mkHost ./hosts/nixos;
      # LUKS-encrypted laptop (Nvidia).  Reimage the current machine with
      # `make install HOST=luks DISK=...` from the live USB.  See LUKS-REINSTALL.md.
      luks = mkHost ./hosts/luks;
      # Desktop (Nvidia).
      desktop = mkHost ./hosts/desktop;
      # Laptop (no discrete GPU).
      laptop = mkHost ./hosts/laptop;
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        clang
        pkg-config
        gnumake
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
