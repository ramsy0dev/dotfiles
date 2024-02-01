#!/usr/bin/bash

# Install yay
echo " [ + ] Installing yay..."

sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Install wayland, hyprland
echo " [ + ] Installing hyprland-git..."

yay -Syyu
yay -S hyprland-git

# Install deps
echo " [ + ] Installing the following deps: nemo, git, python, python-pip, neovim, dunst, htop, kitty, neofetch, qt6ct, rofi, eza, alacritty..."

yay -S nemo git python python-pip neovim waybar dunst htop kitty neofetch qt6ct rofi eza alacritty curl zip unzip grim slurp qt6-wayland

# Installing the Hack nerd font
echo " [ + ] Installing the Hack Nerd font..."

font_name="Hack"

echo " [ + ] Font url: https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.zip"
curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.zip"
echo " [ + ] creating fonts folder: ${HOME}/.fonts"
mkdir -p  "$HOME/.fonts"
echo " [ + ] unzip the $font_name.zip"
unzip "$font_name.zip" -d "$HOME/.fonts/$font_name/" && rm "./$font_name.zip"
fc-cache -fv

# Copying config files to $HOME/.config
echo " [ + ] Copying config files to $HOME/.config ..."

cp ./configs/* $HOME/.config/ -r

echo " [ + ] Finished!!!!"

