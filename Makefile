# Fully automated install / update for the flake.
#
# Encrypted hosts (luks/desktop/laptop) share one disk layout in
# modules/nixos/disko.nix; the target block device is named `main` and is
# chosen at install time on the command line (deliberately NOT hardcoded, so
# you cannot accidentally wipe the wrong disk).  From a NixOS minimal ISO,
# after cloning the repo:
#
#   make install HOST=luks DISK=/dev/disk/by-id/nvme-...
#
# disko-install reads the host's disko layout from the flake, partitions +
# LUKS-encrypts + formats + mounts `DISK`, injects your secrets and the flake
# repo, then runs `nixos-install` — everything in one declarative step.
# Missing source paths (age key dir, /var/lib/tailscale) are created for you,
# so a brand-new live ISO needs no manual prep beyond cloning.  The sops age
# key is shared across all machines (AGE_KEY / ~/.config/sops/age/keys.txt);
# SSH keys are per-machine (`make ssh-keygen`), or restored on a reimage with
# SSH_SRC=$HOME/.ssh.

HOST ?= luks
DISK ?= /dev/disk/by-id/CHANGE-ME

# Flake repo staged into the new root at ~/nixos so the installed system
# boots with its config in place.  On a live ISO this is the clone (default
# /tmp/nixos).  Disable with REPO= (empty).
REPO ?= /tmp/nixos

# Per-machine SSH keys.  Empty by default — every computer generates its own
# key (`make ssh-keygen` after boot) so they are never shared.  On a reimage,
# set SSH_SRC=$HOME/.ssh to restore that machine's own keys instead.
SSH_SRC ?=

# sops age key — REQUIRED: without it secrets/secrets.yaml can't be decrypted
# at first boot.  Falls back to ~/.config/sops/age/keys.txt if unset.
AGE_KEY ?= $(HOME)/.config/sops/age/keys.txt

.PHONY: install install-no-secrets mount dry-run check build rebuild update help gen-key refresh-secrets ssh-keygen

default: rebuild

## install — wipe + reclaim + LUKS-encrypt + format + install HOST onto DISK (⚠ wipes DISK)
install:
	@test "$(DISK)" != "/dev/disk/by-id/CHANGE-ME" || { echo "DISK not set — run: make install HOST=$(HOST) DISK=/dev/disk/by-id/<disk>"; exit 1; }
	@test "$$(nix eval .#nixosConfigurations.$(HOST).config.hardware.fullDiskEncryption 2>/dev/null)" = "true" || { echo "$(HOST) does not declare LUKS encryption — refusing to install (all installs must be encrypted)"; exit 1; }
	@echo "⚠  This DESTROYS $(DISK) and reinstalls $(HOST) on it. Type $(HOST) to continue:"
	@read -r c; test "$$c" = "$(HOST)" || { echo "aborted"; exit 1; }
	mkdir -p $(HOME)/.config/sops/age
	sudo mkdir -p /var/lib/tailscale
	@test -f $(AGE_KEY) || { echo "no age key at $(AGE_KEY) — copy the shared key here (same one on every machine)"; exit 1; }
	sudo -E nix run github:nix-community/disko/latest#disko-install -- \
		--flake .#$(HOST) --disk main $(DISK) \
		--extra-files $(AGE_KEY) /home/ioe/.config/sops/age/keys.txt \
		--extra-files /var/lib/tailscale/. /var/lib/tailscale \
		$(if $(SSH_SRC),$(if $(wildcard $(SSH_SRC)/.),--extra-files $(SSH_SRC)/. /home/ioe/.ssh)) \
		$(if $(wildcard $(REPO)/flake.nix),--extra-files $(REPO)/. /home/ioe/nixos) \
		--write-efi-boot-entries

## install-no-secrets — same as install but without injecting the shared age key (restore it yourself)
install-no-secrets:
	@test "$$(nix eval .#nixosConfigurations.$(HOST).config.hardware.fullDiskEncryption 2>/dev/null)" = "true" || { echo "$(HOST) does not declare LUKS encryption — refusing to install (all installs must be encrypted)"; exit 1; }
	sudo nix run github:nix-community/disko/latest#disko-install -- \
		--flake .#$(HOST) --disk main $(DISK) --write-efi-boot-entries

## gen-key — rotate/mint the sops age key (prints its public key; only for a deliberate shared-key rotation)
gen-key:
	mkdir -p $(dir $(AGE_KEY))
	@test -f $(AGE_KEY) || nix shell nixpkgs#age -c age-keygen -o $(AGE_KEY)
	@echo "age key:        $(AGE_KEY)"
	@echo "public key:"
	nix shell nixpkgs#age -c age-keygen -y $(AGE_KEY)
	@echo "Add it to .sops.yaml (keys and key_groups) and run 'make refresh-secrets'."

## refresh-secrets — re-encrypt/create secrets/secrets.yaml with the .sops.yaml keys
refresh-secrets:
	nix shell nixpkgs#sops -c sops secrets/secrets.yaml

## ssh-keygen — create a fresh per-machine SSH key (prints its public key)
ssh-keygen:
	mkdir -p $(HOME)/.ssh
	@test -f $(HOME)/.ssh/id_ed25519 || ssh-keygen -t ed25519 -N "" -f $(HOME)/.ssh/id_ed25519 -C "$(HOST)"
	@echo "per-machine key: $(HOME)/.ssh/id_ed25519"
	@echo "public key:"
	cat $(HOME)/.ssh/id_ed25519.pub
	@echo "Add it where needed, then: sudo tailscale up --ssh"

## mount — only mount DISK at /mnt/disko-install-root (no wipe, no install)
mount:
	sudo nix run github:nix-community/disko/latest#disko-install -- \
		--flake .#$(HOST) --disk main $(DISK) --mode mount

## dry-run — preview the exact install commands without touching anything
dry-run:
	nix run github:nix-community/disko/latest#disko-install -- \
		--flake .#$(HOST) --disk main $(DISK) --dry-run

## check — evaluate every host configuration
check:
	nix flake check

## build — build every host's system image
build:
	@for h in nixos luks desktop laptop; do \
		nix build .#nixosConfigurations.$$h.config.system.build.toplevel --no-link || exit 1; \
	done
	@echo "all hosts built OK"

## rebuild — rebuild and switch current host with nh
rebuild:
	nh os switch

## update — refresh all inputs and re-check
update:
	nix flake update
	nix flake check

help:
	@grep -E '^## ' Makefile | sed 's/^## //' | awk -F' — ' '{printf "  \033[1m%-9s\033[0m %s\n", $$1, $$2}'
