function fnc_user_config() {
    usermod -s $(which zsh) $user
}

function fnc_gen_dirs() {
    local dirs=("Cloud" "Projects" "VMs" "ISOs")
    for dir in "${dirs[@]}"; do
        su --session-command="mkdir ~/$dir" $user
    done
}

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

function fnc_install_grub() {
    if [ $disk_label = gpt ]; then
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    else
        grub-install --target=i386-pc /dev/$disk
    fi
    grub-mkconfig -o /boot/grub/grub.cfg
}

function fnc_config_pkgs() {
    if pacman -Q bluez &> /dev/null; then
        systemctl enable bluetooth
    fi
    if pacman -Q virt-manager &> /dev/null; then
        systemctl enable libvirtd.socket
        usermod -aG libvirt $user
    fi
    if pacman -Q keyd &> /dev/null; then
        systemctl enable keyd
        usermod -aG keyd $user
    fi
    if pacman -Q firewalld &> /dev/null; then
        systemctl enable firewalld
    fi
    if pacman -Q ufw &> /dev/null; then
        # FIX: initcaps error
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
    if pacman -Q jellyfin-server &> /dev/null; then
        ufw allow 8096/tcp
    fi
    if pacman -Q waybar &> /dev/null; then
        usermod -aG input $user
    fi
    if pacman -Q waydroid &> /dev/null; then
        systemctl enable waydroid-container
        ufw allow 67
        ufw allow 53
        ufw default allow FORWARD
    fi
    if pacman -Q ufw &> /dev/null && pacman -Q virt-manager &> /dev/null; then
        echo 'firewall_backend = "iptables"' > /etc/libvirt/network.conf
    fi
}


function fnc_gh_dotfiles() {
    local repo_dir="/home/$user/Projects/dotfiles"

    su --session-command="git clone 'https://github.com/$1/$2' '$repo_dir'"
}

function fnc_install_omz() {
    # TODO: bypass password
    su - --session-command='echo "\n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"' $user
}

function fnc_install_yay() {
    # TODO: bypass password
    git clone https://aur.archlinux.org/yay.git /home/$user/yay
    chown -R $user:$user /home/$user/yay
    cd /home/$user/yay
    su --session-command="makepkg -si" $user
    cd
    rm -rf /home/$user/yay
}
