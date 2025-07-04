#!/usr/bin/env bash

set -e
cd $(dirname $0)

source functions.sh
prompt_vars
get_vars
check_vars

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

pacman -Syy

if [ $disk_label = gpt ]; then
    mkfs.fat -F32 /dev/$efi_part
    mount --mkdir /dev/$efi_part /mnt/boot
fi

pacstrap -K /mnt $(tr '\n' ' ' < ./resources/pkgs)

genfstab -U /mnt > /mnt/etc/fstab

cp -r ../install-scripts /mnt/root/install-scripts

echo "root:$root_pass" | chpasswd --root /mnt
useradd -mG wheel $user --root /mnt
echo "$user:$user_pass" | chpasswd --root /mnt

sed -i 's|#en_US.UTF-8|en_US.UTF-8|' /mnt/etc/locale.gen
echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf
echo 'arch' > /mnt/etc/hostname
sed -i 's|block filesystems|block encrypt filesystems|' /mnt/etc/mkinitcpio.conf
sed -i "s|quiet|quiet cryptdevice=UUID=$(blkid -s UUID -o value /dev/$root_part):root root=/dev/mapper/root|" /mnt/etc/default/grub
sed -i 's|# %wheel ALL=(ALL:ALL) ALL|%wheel ALL=(ALL:ALL) ALL|' /mnt/etc/sudoers
sed -i 's|# deny = 3|deny = 5|' /mnt/etc/security/faillock.conf

arch-chroot /mnt "disk=$disk /root/install-scripts/install-chroot.sh"
exit 0
