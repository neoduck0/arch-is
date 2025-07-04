#!/usr/bin/env bash

set -e

cd $(dirname $0)
script_root=$(pwd)
project_name=$(basename script_root)

source helpers-core.sh

./pkgs.py hyprland

fnc_init_vars

fnc_disk

fnc_install_linux

fnc_gen_fstab

fnc_config_users

fnc_support_encryption

fnc_config_faillock

cp -r $script_root /mnt/root/$project_name
arch-chroot /mnt "user=$user disk=$disk disk_label=$disk_label /root/$project_name/install-chroot.sh"
exit 0
