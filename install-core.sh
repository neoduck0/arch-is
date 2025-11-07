#!/usr/bin/env bash

set -e
cd $(dirname $0)

source functions.sh
prompt_vars
get_vars

# disk
if [ $disk_label = gpt ]; then
    sgdisk --zap-all /dev/$disk
    sgdisk --new=1:0:+1G /dev/$disk
    sgdisk --new=2:0:0 /dev/$disk
elif [ $disk_label = mbr ]; then
    wipefs -a /dev/$disk
    parted /dev/sda mklabel msdos --script
    parted /dev/sda mkpart primary ext4 0% 100% --script
fi

echo -n "$disk_pass" | cryptsetup luksFormat --batch-mode /dev/$root_part
echo -n "$disk_pass" | cryptsetup luksOpen --batch-mode /dev/$root_part root
mkfs.ext4 /dev/mapper/root -F
mount /dev/mapper/root /mnt

if [ $disk_label = gpt ]; then
    mkfs.fat -F32 /dev/$efi_part
    mount --mkdir /dev/$efi_part /mnt/boot
fi

# installation
pacman -Syy
pacstrap -K /mnt $(tr '\n' ' ' < ./resources/pkgs)

# fstab
genfstab -U /mnt > /mnt/etc/fstab

# users
echo "root:$root_pass" | chpasswd --root /mnt
useradd -mG wheel $user --root /mnt
echo "$user:$user_pass" | chpasswd --root /mnt

# encryption
sed -i 's|block filesystems|block encrypt filesystems|' /mnt/etc/mkinitcpio.conf
sed -i "s|quiet|quiet cryptdevice=UUID=$(blkid -s UUID -o value /dev/$root_part):root root=/dev/mapper/root|" /mnt/etc/default/grub

# security changes
sed -i 's|# %wheel ALL=(ALL:ALL) ALL|%wheel ALL=(ALL:ALL) ALL|' /mnt/etc/sudoers
sed -i 's|# deny = 3|deny = 5|' /mnt/etc/security/faillock.conf

cp -r ../install-scripts /mnt/root/install-scripts
arch-chroot /mnt "disk=$disk /root/install-scripts/install-chroot.sh"
exit 0
