# Usage:
default: rebuild

rebuild:
	nh os switch . -H nixos --diff always

build:
	nh os build . -H nixos --diff always

check:
	nix flake check

format:
	nix build .#formatter.x86_64-linux --out-link /tmp/nixos-alejandra
	/tmp/nixos-alejandra/bin/alejandra .

update:
	nix flake update
	nh os switch . -H nixos --diff always