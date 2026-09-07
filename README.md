# NixOS Configuration

Declarative, multi-host NixOS setup with **LUKS full-disk encryption** (via
[disko](https://github.com/nix-community/disko)), **home-manager**, and
**sops-nix** secrets.  Every machine is installed with one command; the disk
layout lives in exactly one place and is shared by all encrypted hosts.

## Highlights

- **One-command install** — `make install HOST=<name> DISK=<device>` wipes,
  partitions, LUKS-encrypts, formats, injects your secrets, and runs
  `nixos-install` in a single declarative step.
- **Encryption is enforced, not optional** — `make install` refuses any host
  that doesn't declare LUKS encryption (`hardware.fullDiskEncryption`), and
  the shared disko layout fails evaluation if `/` isn't on a `/dev/mapper/*`
  device.
- **Shared disk layout** — `modules/nixos/disko.nix` holds the layout once;
  every encrypted host uses it.  The target disk is chosen at install time, so
  the same flake installs onto any drive.
- **Full-disk encryption** — 1G ESP (`/boot`, unencrypted, as required by EFI)
  + LUKS2 `cryptroot` (ext4 `/`).  The swapfile lives inside the encrypted
  root, so swap is encrypted too.  Optional TPM2 auto-unlock.
- **Identical everywhere, configurable per-host** — GPU, hostname, and disk
  differ per host; everything else (networking, security, base, home-manager)
  is shared.
- **Secrets managed with sops** — config is public; secrets are encrypted.

## Hosts

| host      | status                 | GPU           | disk           |
|-----------|------------------------|---------------|----------------|
| `nixos`   | current machine      | Nvidia        | ext4 (no LUKS) |
| `luks`    | encrypted laptop     | Nvidia        | chosen at install |
| `desktop` | encrypted desktop    | Nvidia        | chosen at install |
| `laptop`  | encrypted GPU-less    | integrated    | chosen at install |

> `nixos` is the transitional, **unencrypted** host you are running now.  The
> long-term setup is the `luks` host, which installs the same machine with
> full-disk encryption.  See [Installing an encrypted host](#installing-an-encrypted-host).

## Repository layout

```
flake.nix                  # inputs + all hosts registered
variables.nix              # username, timezone, locale, stateVersion
Makefile                   # make install / mount / dry-run / check / build / update
modules/nixos/             # shared NixOS modules, imported by every host
  base.nix                 #   core system config
  disko.nix                #   the single shared LUKS disk layout
  hardware-gpu.nix         #   hardware.graphicsAccel option (gates Nvidia)
  networking.nix           #   network / sshd / tailscale
  security.nix             #   hardening
  sops.nix                 #   secret decryption
  users.nix                #   user accounts
home/                      # home-manager configuration (identical across hosts)
hosts/<name>/              # per-machine: default.nix + hardware-configuration.nix
secrets/                   # sops-encrypted secrets (committed; safely)
```

Per-host config is minimal — just a hostname, an optional GPU flag, and a disk:

```nix
# hosts/<name>/default.nix
{
  config, lib, pkgs, inputs, vars, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/disko.nix   # shared LUKS layout
    ../../modules/nixos              # shared base
  ];

  networking.hostName = "<name>";
  # hardware.graphicsAccel = "nvidia";  # only if it has a discrete Nvidia GPU

  system.stateVersion = vars.stateVersion;
}
```

---

## Installing an encrypted host

### Quick start

Boot the NixOS minimal ISO, get internet, then:

```console
git clone https://github.com/ioeftedal/nix.git /tmp/nixos
cd /tmp/nixos
# copy the shared sops age key to ~/.config/sops/age/keys.txt first!
lsblk
make install HOST=laptop DISK=/dev/disk/by-id/...
sudo nixos-enter --root /mnt/disko-install-root -- passwd ioe
reboot
# after reboot:
cd ~/nixos && git push
make ssh-keygen
sudo tailscale up --ssh
sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-id/...
```

Pick the right `HOST` (`luks`, `desktop`, or `laptop`) for your machine.

### Full walkthrough

Designed to run from the **NixOS minimal installation ISO** (which ships with
`git`, `nix`, and networking).  Everything is automated behind `make install`.

### Prerequisites

1. **A `secrets` age key exists on the ISO.**  `make install` copies
   `~/.config/sops/age/keys.txt` into the new root so secrets can be decrypted
   at first boot.  If it isn't present, use `make install-no-secrets` and
   restore the key yourself before rebooting.
2. **The target host's `hardware-configuration.nix` is already committed.**
   For a new machine, generate it first (see
   [Adding a new host](#adding-a-new-host)).

> ☠️ `make install` **destroys** the target disk.  It asks you to confirm by
> typing the hostname before doing anything.  Back up anything you can't
> regenerate first.

### 1. Boot the ISO and connect

```console
# plug in ethernet, or use a graphical ISO and connect to Wi-Fi
ping -c 2 github.com
```

### 2. Clone the repo

Clone over **HTTPS** (default — works from a fresh ISO with no keys; enter
your GitHub username and a Personal Access Token when prompted):

```console
git clone https://github.com/ioeftedal/nix.git
cd nix
```

> SSH keys are per-machine (generated after first boot with `make
> ssh-keygen`), so the clone method on the ISO doesn't matter.  If you already
> have keys on the ISO, `git clone git@github.com:ioeftedal/nix.git` works
> too.

### 3. One command: partition + encrypt + install

```console
# Preview first (does nothing):
make dry-run HOST=luks DISK=/dev/disk/by-id/...

# Then install (prompts for confirm + a LUKS passphrase):
make install HOST=luks DISK=/dev/disk/by-id/...
```

Find the right `DISK` with:

```console
lsblk -o NAME,SIZE,MODEL
ls /dev/disk/by-id/
```

This runs `disko-install`, which for `HOST=luks` on `DISK` does all of:

1. wipes the disk and creates a GPT layout (1G EFI + LUKS2 partition),
2. prompts for a **strong LUKS passphrase** and encrypts,
3. creates the ext4 root and mounts everything,
4. injects the shared sops age key and tailscale state (SSH keys are
   per-machine and generated after first boot),
5. runs `nixos-install`, and
6. writes the EFI boot entries.

### 4. First boot

```console
# disko-install mounts the new system at /mnt/disko-install-root.
# Set ioe's password (user passwords are NOT declarative across reimages):
sudo nixos-enter --root /mnt/disko-install-root -- passwd ioe

reboot
```

After reboot, on the new system:

```console
cd ~/nixos && git push && sudo ln -sfn /home/ioe/nixos /etc/nixos
make ssh-keygen            # this machine's OWN ssh key (per-machine)
sudo tailscale up --ssh    # per-node ssh identity on the tailnet
```

### 5. Optional: TPM2 auto-unlock

Enroll the TPM so future boots unlock without a passphrase:

```console
sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-id/<real-id>
reboot   # should now unlock with no prompt
```

The LUKS passphrase you set during install remains the master recovery — write
it down offline.

---

## Adding a new host

Adding a machine to the fleet is a short, then fully-automated, process.

1. **Bootstrap an encrypted layout on the machine (from the ISO):**
   ```console
   git clone https://github.com/ioeftedal/nix.git /tmp/nixos
   cd /tmp/nixos
   # create the host by copying an existing encrypted host
   cp -r hosts/luks hosts/<name>
   ```
2. **Set its hostname** in `hosts/<name>/default.nix`; add
   `hardware.graphicsAccel = "nvidia";` only if it has a discrete Nvidia GPU.
3. **Generate + commit its hardware config** (auto-detects CPU vendor, kernel
   modules, and integrated GPU):
   ```console
   nixos-generate-config --no-filesystems --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix hosts/<name>/
   git add -A && git commit -m "Add host <name>"
   git push
   ```
4. **Register it** in `flake.nix`:
   ```nix
   nixosConfigurations.<name> = mkHost ./hosts/<name>;
   ```
5. **Install** (same one-command flow as above):
   ```console
   make dry-run HOST=<name> DISK=/dev/disk/by-id/...   # preview
   make install HOST=<name> DISK=/dev/disk/by-id/...
   ```

---

## Common tasks

```console
make check    # evaluate every host configuration
make build    # build all hosts' systems (no install)
make update   # refresh inputs and re-check
```

On an installed machine, changes to the flake are applied with:

```console
# on the machine itself, in the repo:
sudo nixos-rebuild switch --flake /home/ioe/nixos#<name>
```

---

## Secrets (sops)

- `secrets/secrets.yaml` is **encrypted** and committed.
- Decryption requires the private age key at
  `~/.config/sops/age/keys.txt`, which is **gitignored** and never pushed.
- One **shared** age key is used on every machine — carry the same `keys.txt`
  onto each install.  (SSH keys are the opposite: per-machine.)
- **Losing the age key makes secrets undecryptable** — back it up offline.

---

## Notes & gotchas

- The `nixos` host in the table is the unencrypted transitional host.  The
  intended final state is with every machine encrypted (via `luks` /
  `desktop` / `laptop`).
- The disk device is deliberately **not** hardcoded in the config; it is always
  passed explicitly at install time to prevent wiping the wrong disk.
- Every install is guaranteed **LUKS-encrypted**: `make install` refuses hosts
  without `hardware.fullDiskEncryption`, and the shared disko layout
  (`modules/nixos/disko.nix`) fails evaluation if the root isn't a LUKS
  mapping.
- `system.stateVersion` is set from `variables.nix` and should not be bumped
  casually.
