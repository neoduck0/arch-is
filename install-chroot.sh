#!/usr/bin/env bash

# quit on error
set -e

# go to project directory
cd $(dirname $0)
project_dir=$(pwd)

source helpers-chroot.sh

fnc_gen_dirs

fnc_set_locales

fnc_install_grub

fnc_config_pkgs

fnc_install_omz

fnc_install_yay

fnc_gh_dotfiles neoduck0

# delete project files
cd /
rm -rf $project_dir

clear
echo "chroot script finished."
exit 0
