#!/bin/bash

# Pastikan script dijalankan sebagai root/sudo
if [[ $EUID -ne 0 ]]; then
   echo "Jalankan script ini sebagai root/sudo!"
   exit 1
fi

# Update sistem
echo "===> Update sistem"
pacman -Syu --noconfirm

# Install yay (jika belum ada)
if ! command -v yay &> /dev/null; then
  echo "===> Install yay (AUR Helper)"
  pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd ~
  rm -rf /tmp/yay
fi

# Daftar aplikasi dari repositori resmi
APPS=(
  waybar
  thunar
  sddm
  kitty
  zsh
  git
  neovim
  tmux
  curl
  wget
  gcc
  make
  nodejs
  npm
  python
  python-pip
  docker
  docker-compose
  htop
  net-tools
  unzip
  zip
)

echo "===> Install aplikasi penting dari repositori resmi"
for app in "${APPS[@]}"; do
  pacman -S --noconfirm --needed "$app"
done

# Daftar aplikasi dari AUR
AUR_APPS=(
  swww         # Wallpaper daemon (AUR)
  google-chrome
  visual-studio-code-bin
  lazygit
  nvm
  bat
  fd
  ripgrep
  starship
)

echo "===> Install aplikasi dari AUR menggunakan yay"
for app in "${AUR_APPS[@]}"; do
  yay -S --noconfirm --needed "$app"
done

# Aktifkan SDDM
echo "===> Mengaktifkan SDDM (Display Manager)"
systemctl enable sddm

echo "===> Instalasi selesai!"