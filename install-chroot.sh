#!/usr/bin/env bash

# quit on error
set -e

# go to project directory
cd $(dirname $0)
script_root=$(pwd)

source helpers-chroot.sh

fnc_user_config

fnc_gen_dirs

fnc_set_locales

fnc_install_grub

fnc_config_pkgs

fnc_gh_dotfiles neoduck0 dotfiles

fnc_install_omz

fnc_install_yay

# delete project files
cd /
rm -rf $script_root

clear
echo "chroot script finished."
exit 0
