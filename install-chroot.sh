#!/usr/bin/env bash

set -e
cd $(dirname $0)

source functions.sh
get_vars

# locales
sed -i 's|#en_US.UTF-8|en_US.UTF-8|' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'arch' > /etc/hostname
timezone=$(curl -s https://ipinfo.io/timezone)
if [ ! -f "/usr/share/zoneinfo/$timezone" ]; then
    timezone="UTC"
fi
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

# grub
if [ $disk_label = gpt ]; then
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
else
    grub-install --target=i386-pc /dev/$disk
fi
grub-mkconfig -o /boot/grub/grub.cfg

# systemd services
if pacman -Q bluez &> /dev/null; then
    systemctl enable bluetooth
fi
if pacman -Q libvirt &> /dev/null; then
    systemctl enable libvirtd.socket
    usermod -aG libvirt $user
fi
if pacman -Q keyd &> /dev/null; then
    cp ./resources/keyd.conf /etc/keyd/default.conf
    systemctl enable keyd
    keyd reload
    usermod -aG keyd $user
fi
if pacman -Q firewalld &> /dev/null; then
    systemctl enable firewalld
fi
if pacman -Q ufw &> /dev/null; then
    systemctl enable ufw
    ufw limit 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw default deny incoming
    ufw default allow outgoing
    ufw enable
    echo 'firewall_backend = "iptables"' > /etc/libvirt/network.conf
fi
if pacman -Q networkmanager &> /dev/null; then
    systemctl enable NetworkManager
fi
if pacman -Q jellyfin-server &> /dev/null; then
    ufw allow 8096/tcp
fi
if pacman -Q waybar &> /dev/null; then
    usermod -aG input $user
fi

# omz
su --session-command='sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"' $user

# yay
git clone https://aur.archlinux.org/yay.git /home/$user/yay
chown -R $user:$user /home/$user/yay
cd /home/$user/yay
su --session-command="makepkg -si" $user
cd
rm -rf /home/$user/yay

rm -rf /root/install-scripts

echo
echo "chroot script finished"
exit 0
