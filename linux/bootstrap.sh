#!/usr/bin/env bash
set -euo pipefail

read -rp "Enter new Linux username [iamvoid]: " USERNAME
USERNAME="${USERNAME:-iamvoid}"

DOTFILES_REPO="https://github.com"

echo "==> Initializing pacman keyring and updating system..."
pacman-key --init
pacman-key --populate archlinux
pacman -Syu --noconfirm

echo "==> Installing base tools..."
pacman -S --needed --noconfirm git zsh sudo

echo "==> Creating user '$USERNAME' and configuring sudo..."
if ! id "$USERNAME" &>/dev/null; then
    useradd -m -G wheel -s /usr/bin/zsh "$USERNAME"
    echo "==> Set password for '$USERNAME':"
    passwd "$USERNAME"
else
    chsh -s /usr/bin/zsh "$USERNAME"
fi

echo "%wheel ALL=(ALL:ALL) ALL" >/etc/sudoers.d/wheel
chmod 0440 /etc/sudoers.d/wheel

echo "==> Writing /etc/wsl.conf..."
cat <<EOF >/etc/wsl.conf
[boot]
systemd=true

[user]
default=$USERNAME
EOF

echo "==> Cloning dotfiles and symlinking configs as '$USERNAME'..."
sudo -u "$USERNAME" bash <<EOF
set -euo pipefail
cd "/home/$USERNAME"

if [ ! -d "dotfiles" ]; then
    git clone "$DOTFILES_REPO" dotfiles
fi

# 1. Symlink top-level dotfiles (skipping .config, .git, and .zcompdump)
for item in dotfiles/linux/.*; do
    name=\$(basename "\$item")
    case "\$name" in
        .|..|.config|.git|.gitignore|.zcompdump*) continue ;;
    esac
    rm -rf "/home/$USERNAME/\$name"
    ln -s "/home/$USERNAME/\$item" "/home/$USERNAME/\$name"
done

# 2. Symlink ~/.config subfolders individually so new apps don't dirty the repo
mkdir -p "/home/$USERNAME/.config"
for cfg in dotfiles/linux/.config/*; do
    cfg_name=\$(basename "\$cfg")
    rm -rf "/home/$USERNAME/.config/\$cfg_name"
    ln -s "/home/$USERNAME/\$cfg" "/home/$USERNAME/.config/\$cfg_name"
done
EOF

if [ -f "/home/$USERNAME/dotfiles/linux/packages.txt" ]; then
    echo "==> Installing packages from packages.txt..."
    grep -vE '^\s*#|^\s*$' "/home/$USERNAME/dotfiles/linux/packages.txt" | pacman -S --needed --noconfirm -
fi

echo ""
