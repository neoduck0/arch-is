#!/bin/bash
set -euo pipefail

mkinitcpio -p linux

function fnc_set_locales() {
    sed -i 's|#en_US.UTF-8|en_US.UTF-8|' /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo 'arch' > /etc/hostname
    local timezone=$(curl -s https://ipinfo.io/timezone)
    if [ ! -f "/usr/share/zoneinfo/$timezone" ]; then
        timezone="UTC"
    fi
    ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
    hwclock --systohc
}
fnc_set_locales

function fnc_install_grub() {
    if [ $disk_label = gpt ]; then
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    else
        grub-install --target=i386-pc /dev/$disk
    fi
    grub-mkconfig -o /boot/grub/grub.cfg
}
fnc_install_grub

cd /
rm -rf $script_root

clear
echo "chroot script finished."
exit 0
