#!/usr/bin/env bash

set -e
cd $(dirname $0)

source functions.sh
get_vars

ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
locale-gen

if [ $disk_label = gpt ]; then
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
else
    grub-install --target=i386-pc /dev/$disk
fi

grub-mkconfig -o /boot/grub/grub.cfg

systemd_services

su --session-command='sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"' $user

git clone https://aur.archlinux.org/yay.git /home/$user/yay
chown -R $user:$user /home/$user/yay
cd /home/$user/yay
su --session-command="makepkg -si" $user
cd
rm -rf /home/$user/yay

cd
rm -rf /root/install-scripts

echo
echo "chroot script finished"
exit 0
