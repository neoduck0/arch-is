#!/usr/bin/env python

import os

os.chdir(os.path.dirname(os.path.abspath(__file__)))

BASIC = [
        "base",
        "base-devel",
        "bash-language-server",
        "btop",
        "btrfs-progs",
        "clang",
        "curl",
        "docker",
        "docker-compose",
        "dosfstools",
        "efibootmgr" if not os.path.exists("/sys/firmware/uefi") else None,
        "exfatprogs",
        "fastfetch",
        "fd",
        "fuse2",
        "git",
        "go",
        "gopls",
        "gptfdisk",
        "grub",
        "intel-ucode",
        "keyd",
        "linux",
        "linux-firmware",
        "lua-language-server",
        "man-db",
        "neovim",
        "networkmanager",
        "nodejs",
        "npm",
        "ntfs-3g",
        "openconnect",
        "openssh",
        "openvpn",
        "pacman-contrib",
        "pyright",
        "python-pip",
        "rclone",
        "reflector",
        "ripgrep",
        "rust",
        "sudo",
        "udisks2",
        "ufw",
        "unzip",
        "usbutils",
        "wget",
        "zip",
        "zsh",
        ]
try:
    BASIC.remove(None)
except:
    pass

DESKTOP = [
        "accountsservice",
        "android-tools",
        "bluez",
        "bluez-utils",
        "deluge-gtk",
        "ffmpeg",
        "flatpak",
        "gvfs-mtp",
        "imagemagick",
        "noto-fonts",
        "noto-fonts-cjk",
        "noto-fonts-emoji",
        "pandoc-cli",
        "pipewire",
        "pipewire-alsa",
        "pipewire-jack",
        "pipewire-pulse",
        "scrcpy",
        "sof-firmware",
        "ttf-jetbrains-mono-nerd",
        "vulkan-icd-loader",
        "vulkan-intel",
        "wireplumber",
        "yt-dlp"
        ]

PROFILES = {
        "server": BASIC,
        "hyprland": [
            "amberol",
            "bluetui",
            "brightnessctl",
            "cliphist",
            "eartag",
            "gnome-calculator",
            "gnome-clocks",
            "grim",
            "gtk-engine-murrine",
            "hypridle",
            "hyprland",
            "hyprlock",
            "hyprpaper",
            "hyprpicker",
            "kitty",
            "loupe",
            "mako",
            "morphosis",
            "nautilus",
            "papers",
            "pavucontrol",
            "pdfarranger",
            "polkit-gnome",
            "power-profiles-daemon",
            "qt5-wayland",
            "qt6-wayland",
            "rofi-wayland",
            "slurp",
            "snapshot",
            "solanum",
            "uwsm",
            "vlc",
            "vlc-plugins-all",
            "waybar",
            "wev",
            "wl-clip-persist",
            "wl-clipboard",
            "xdg-desktop-portal-gtk",
            "xdg-desktop-portal-hyprland",
            "xdg-user-dirs",
            "zed",
            ]
        + BASIC
        + DESKTOP
        }

OPTS = {
        "virtualization": [
            "dmidecode",
            "dnsmasq",
            "qemu-full",
            "spice-vdagent",
            "swtpm",
            "virt-manager"
            ],
        "office": [
            "libreoffice-fresh"
            ],
        "vpn": [
            "proton-vpn-gtk-app"
            ]
        }

def diff(excluded_opts=[]):
    selected = PROFILES["hyprland"]

    os.system("""
              pacman -Qeq > 1
              """)

    for OPT in OPTS:
        if OPT not in excluded_opts:
            selected += OPTS[OPT]

    selected.sort()

    with open("2", "w") as f:
        for pkg in selected:
            f.write(f"{pkg}\n")

    os.system("""
              diff 2 1
              rm 1 2
              """)

diff()
