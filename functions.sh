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
