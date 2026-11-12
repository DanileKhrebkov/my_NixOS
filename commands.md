```bash
nmtui
ping -c 2 nixos.org
lsblk
parted /dev/sdX -- mklabel gpt
parted /dev/sdX -- mkpart ESP fat32 1MiB 1024MiB
parted /dev/sdX -- set 1 esp on
parted /dev/sdX -- mkpart primary 1024MiB 100%
mkfs.fat -F 32 -n boot /dev/sdX1
mkfs.ext4 -L nixos /dev/sdX2
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
nix-shell -p git
git clone https://github.com/DanileKhrebkov/my_NixOS /mnt/etc/nixos
nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix
cd /mnt/etc/nixos
nixos-install --flake .#nixos
passwd
reboot
cd /etc/nixos
nixos-rebuild switch --flake .#nixos
```