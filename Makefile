# Common tasks for the flake.
#
# Installing a NixOS machine (desktop/laptop) is a manual, plain NixOS flow:
# boot the ISO, partition + format the disk yourself, mount it, generate the
# hardware config, then:
#
#   sudo nixos-install --flake .#<name> --root /mnt
#
# Nix-darwin machines (the Mac fleet) are separate; after setting them up you
# can `nix run nix-darwin -- switch --flake .#macbook`, or build the config
# from any machine with `make build-darwin`.

# Machine to target: defaults to the current machine's hostname, which matches
# the per-machine config names (desktop, laptop).  Override with HOST=...
HOST ?= $(shell hostname -s)

# Per-machine SSH keys.  Empty by default — every computer generates its own
# key (`make ssh-keygen` after boot) so they are never shared.
SSH_SRC ?=

# sops age key — shared across every machine.  Secrets/secrets.yaml is
# encrypted for this key (see .sops.yaml); without it nothing can be decrypted.
AGE_KEY ?= $(HOME)/.config/sops/age/keys.txt

.PHONY: switch check build build-darwin rebuild update help ssh-keygen gen-key refresh-secrets

default: rebuild

## switch — rebuild and switch the current live machine to HOST
switch:
	sudo nixos-rebuild switch --flake .#$(HOST)

## ssh-keygen — create a fresh per-machine SSH key (prints its public key)
ssh-keygen:
	mkdir -p $(HOME)/.ssh
	@test -f $(HOME)/.ssh/id_ed25519 || ssh-keygen -t ed25519 -N "" -f $(HOME)/.ssh/id_ed25519 -C "$(HOST)"
	@echo "per-machine key: $(HOME)/.ssh/id_ed25519"
	@echo "public key:"
	cat $(HOME)/.ssh/id_ed25519.pub
	@echo "Add it where needed, then: sudo tailscale up --ssh"

## gen-key — mint the shared sops age key (prints its public key; only for a deliberate rotation)
gen-key:
	mkdir -p $(dir $(AGE_KEY))
	@test -f $(AGE_KEY) || nix shell nixpkgs#age -c age-keygen -o $(AGE_KEY)
	@echo "age key:        $(AGE_KEY)"
	@echo "public key:"
	nix shell nixpkgs#age -c age-keygen -y $(AGE_KEY)
	@echo "Add it to .sops.yaml (keys and key_groups), re-encrypt all secrets, then roll it out to every machine."

## refresh-secrets — create/re-encrypt secrets/secrets.yaml with the .sops.yaml keys
refresh-secrets:
	nix shell nixpkgs#sops -c sops secrets/secrets.yaml

## check — evaluate every (nixos + darwin) configuration
check:
	nix flake check

## build — build every NixOS machine's system image (no install)
build:
	@for h in desktop laptop; do \
		nix build .#nixosConfigurations.$$h.config.system.build.toplevel --no-link || exit 1; \
	done
	@echo "all NixOS machines built OK"

## build-darwin — build the darwin system configuration (from any machine)
build-darwin:
	nix build .#darwinConfigurations.macbook.config.system.build.toplevel --no-link

## rebuild — rebuild and switch current host with nh
rebuild:
	nh os switch --hostname $(HOST) /home/ioe/nixos

## update — refresh all inputs and re-check
update:
	nix flake update
	nix flake check

help:
	@grep -E '^## ' Makefile | sed 's/^## //' | awk -F' — ' '{printf "  \033[1m%-9s\033[0m %s\n", $$1, $$2}'