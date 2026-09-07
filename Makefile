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
# LUKS-encrypts + formats + mounts `DISK`, injects your secrets, then runs
# `nixos-install` — everything in one declarative step.

HOST ?= luks
DISK ?= /dev/disk/by-id/CHANGE-ME

# sops age key — REQUIRED: without it secrets/secrets.yaml can't be decrypted
# at first boot.  Falls back to ~/.config/sops/age/keys.txt if unset.
AGE_KEY ?= $(HOME)/.config/sops/age/keys.txt

.PHONY: install install-no-secrets mount dry-run check build update help

## install — wipe + reclaim + LUKS-encrypt + format + install HOST onto DISK (⚠ wipes DISK)
install:
	@echo "⚠  This DESTROYS $(DISK) and reinstalls $(HOST) on it. Type $(HOST) to continue:"
	@read -r c; test "$$c" = "$(HOST)" || { echo "aborted"; exit 1; }
	sudo -E nix run github:nix-community/disko/latest#disko-install -- \
		--flake .#$(HOST) --disk main $(DISK) \
		--extra-files $(AGE_KEY) /home/ioe/.config/sops/age/keys.txt \
		--extra-files $(HOME)/.ssh/. /home/ioe/.ssh \
		--extra-files /var/lib/tailscale/. /var/lib/tailscale \
		--write-efi-boot-entries

## install-no-secrets — same as install but without copying in age key/ssh
install-no-secrets:
	sudo nix run github:nix-community/disko/latest#disko-install -- \
		--flake .#$(HOST) --disk main $(DISK) --write-efi-boot-entries

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

## update — refresh all inputs and re-check
update:
	nix flake update
	nix flake check

help:
	@grep -E '^## ' Makefile | sed 's/^## //' | awk -F' — ' '{printf "  \033[1m%-9s\033[0m %s\n", $$1, $$2}'
