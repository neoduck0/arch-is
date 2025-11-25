#!/usr/bin/env bash

function prompt_vars() {
    read -p "Disk: " disk
    read -p "Disk pass: " disk_pass

    read -p "User: " user
    read -p "User $user password: " user_pass

    read -p "Root password: " root_pass
}

function get_vars() {
    if [ -d "/sys/firmware/efi" ]; then
        disk_label="gpt"
    else
        disk_label="mbr"
    fi

    if [ $disk_label = gpt ]; then
        if [ $disk = nvme0n1 ]; then
            efi_part=$disk'p1'
            root_part=$disk'p2'
        else
            efi_part=$disk'1'
            root_part=$disk'2'
        fi
    elif [ $disk_label = mbr ]; then
        if [ $disk = nvme0n1 ]; then
            root_part=$disk'p1'
        else
            root_part=$disk'1'
        fi
    fi
}

function create_dirs() {
    local dirs=("Cloud" "Projects" "VMs" "ISOs")
    for dir in "${dirs[@]}"; do
        mkdir "/home/$user/$dir"
    done
}

function install_dotfiles() {
    local username="$1"
    local repo_url="https://github.com/$username/dotfiles"
    local repo_dir="/home/$user/Projects/dotfiles"

    mkdir -p "/home/$user/Projects"

    git clone "$repo_url" "$repo_dir"
    cd "$repo_dir"
    chmod +x install.sh
    ./install.sh

    cd -
}
