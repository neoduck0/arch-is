#!/usr/bin/env python

import os, sys

WD = os.path.dirname(os.path.abspath(__file__))

def main():
    os.chdir(WD)

    if len(sys.argv) == 1:
        print("error: provide arguments.")
        sys.exit(1)

    match sys.argv[1]:
        case "diff":
            diff()
        case "prompt":
            prompt()
        case _:
            print("error: arguments invalid.")

def diff():
    selected = PROFILES["hyprland"]

    os.system("""
              pacman -Qeq > 1
              """)

    selected.sort()

    with open("2", "w") as f:
        for pkg in selected:
            f.write(f"{pkg}\n")

    os.system("""
              diff 2 1
              rm 1 2
              """)

def prompt():
    profiles_list = list(PROFILES.keys())
    while True:
        os.system("clear")
        for o in range(len(profiles_list)):
            print(f"{profiles_list[o]}")
        print()
        profile = input("System Profile: ")
        os.system("clear")
        if profile in profiles_list:
            gen_file(profile)
            break


def gen_file(profile):
    pkgs = list(PROFILES[profile])
    pkgs.sort()

    with open("pkgs", "w") as f:
        for pkg in pkgs:
            f.write(pkg + "\n")

BASIC = [
        "base",
        "base-devel",
        "bash-language-server",
        "btop",
        "btrfs-progs",
        "caligula",
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
        "typescript",
        "typescript-language-server",
        "udisks2",
        "ufw",
        "unzip",
        "usbutils",
        "vscode-css-languageserver",
        "vscode-html-languageserver",
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
        "deluge-gtk",
        "dmidecode",
        "dnsmasq",
        "eartag",
        "easyeffects",
        "ffmpeg",
        "firefox",
        "flatpak",
        "gnome-calculator",
        "gnome-clocks",
        "gnome-sound-recorder",
        "gst-plugins-bad",
        "gvfs-mtp",
        "imagemagick",
        "kitty",
        "libreoffice-fresh",
        "loupe",
        "morphosis",
        "mpv",
        "nautilus",
        "noto-fonts",
        "noto-fonts-cjk",
        "noto-fonts-emoji",
        "obs-studio",
        "papers",
        "pdfarranger",
        "pipewire",
        "pipewire-alsa",
        "pipewire-jack",
        "pipewire-pulse",
        "polkit-gnome",
        "proton-vpn-gtk-app",
        "pyside6",
        "scrcpy",
        "shotcut",
        "snapshot",
        "sof-firmware",
        "solanum",
        "spice-vdagent",
        "swtpm",
        "syncplay",
        "ttf-jetbrains-mono-nerd",
        "vulkan-icd-loader",
        "vulkan-intel",
        "wireplumber",
        "yt-dlp"
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

if __name__ == "__main__":
    main()
