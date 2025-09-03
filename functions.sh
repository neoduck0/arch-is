#!/usr/bin/env bash

function prompt_vars() {
    read -p "Disk: " disk
    read -s -p "Disk pass: " disk_pass

    read -p "User: " user
    read -s -p "User $user password: " user_pass

    read -s -p "Root password: " root_pass
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

    timezone=$(curl -s https://ipinfo.io/timezone)
    if [ ! -f "/usr/share/zoneinfo/$timezone" ]; then
        timezone="UTC"
    fi
}

function check_vars() {
    for var in user user_pass root_pass disk disk_pass; do
        if [[ -z "${!var}" ]]; then
            echo "Variable $var is unset or set uncorrectly"
            exit 1
        fi
    done
}

function systemd_services() {
    if pacman -Q bluez &> /dev/null; then
        systemctl enable bluetooth
    fi
    if pacman -Q libvirt &> /dev/null; then
        systemctl enable libvirtd.socket
    fi
    if pacman -Q keyd &> /dev/null; then
        cp ./resources/keyd.conf /etc/keyd/default.conf
        systemctl enable keyd
        keyd reload
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
    fi
    if pacman -Q networkmanager &> /dev/null; then
        systemctl enable NetworkManager
    fi
}
