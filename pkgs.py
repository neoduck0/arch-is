#!/usr/bin/env python

import os, sys

def main():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    try:
        if len(sys.argv[1:]) > 1:
            raise Exception
        arg = sys.argv[1]
    except:
        print("Provide one argument")
        sys.exit(1)

    if arg == "diff":
        diff()
    else:
        print("Provide a valid argument")
        sys.exit(1)

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
        "amberol",
        "android-tools",
        "audacity",
        "bluez",
        "bluez-utils",
        "calf",
        "chromium",
        "code",
        "deluge-gtk",
        "eartag",
        "easyeffects",
        "ffmpeg",
        "flatpak",
        "gnome-calculator",
        "gnome-clocks",
        "gnome-disk-utility",
        "gnome-sound-recorder",
        "gst-plugins-bad",
        "gtk-engine-murrine",
        "gvfs-mtp",
        "imagemagick",
        "kitty",
        "loupe",
        "morphosis",
        "nautilus",
        "noto-fonts",
        "noto-fonts-cjk",
        "noto-fonts-emoji",
        "obs-studio",
        "obsidian",
        "papers",
        "pdfarranger",
        "pipewire",
        "pipewire-alsa",
        "pipewire-jack",
        "pipewire-pulse",
        "polkit-gnome",
        "scrcpy",
        "shotcut",
        "snapshot",
        "sof-firmware",
        "solanum",
        "ttf-jetbrains-mono-nerd",
        "vlc",
        "vlc-plugins-all",
        "vulkan-icd-loader",
        "vulkan-intel",
        "wireplumber",
        "yt-dlp",
        ]

PROFILES = {
        "server": BASIC,
        "hyprland": [
            "bluetui",
            "brightnessctl",
            "cliphist",
            "grim",
            "hypridle",
            "hyprland",
            "hyprlock",
            "hyprpaper",
            "hyprpicker",
            "mako",
            "pavucontrol",
            "power-profiles-daemon",
            "qt5-wayland",
            "qt6-wayland",
            "rofi",
            "slurp",
            "uwsm",
            "waybar",
            "wev",
            "wl-clip-persist",
            "wl-clipboard",
            "xdg-desktop-portal-gtk",
            "xdg-desktop-portal-hyprland",
            "xdg-user-dirs",
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

if __name__ == "__main__":
    main()
