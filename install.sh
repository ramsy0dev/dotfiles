#!/usr/bin/bash

# Constants
FONT_NAME="Hack"

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Install yay
echo " ${GREEN}[ + ]${NC} Installing yay..."

sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Install wayland, hyprland
echo " ${GREEN}[ + ]${NC} Installing hyprland-git..."

yay -Syyu
yay -S hyprland-git

# Install deps
echo " ${GREEN}[ + ]${NC} Installing the following deps: nemo, git, python, python-pip, neovim, dunst, htop, kitty, neofetch, qt6ct, rofi, eza, alacritty, curl, zip, unzip, grim, slurp, qt6-wayland, mpv, xdotool ..."

yay -S nemo git python python-pip neovim waybar dunst htop kitty neofetch qt6ct rofi eza alacritty curl zip unzip grim slurp qt6-wayland mpv xdotool

# Installing the Hack nerd font
echo " ${GREEN}[ + ]${NC} Installing the Hack Nerd font..."

echo " ${GREEN}[ + ]${NC} Font url: https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_NAME.zip"
curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_NAME.zip"
echo " ${GREEN}[ + ]${NC} creating fonts folder: ${HOME}/.fonts"
mkdir -p  "$HOME/.fonts"
echo " ${GREEN}[ + ]${NC} unzip the $FONT_NAME.zip"
unzip "$FONT_NAME.zip" -d "$HOME/.fonts/$FONT_NAME/" && rm "./$FONT_NAME.zip"
fc-cache -fv

# Copying config files to $HOME/.config
echo " ${GREEN}[ + ]${NC} Copying config files to $HOME/.config ..."

cp ./configs/* $HOME/.config/ -r

echo " [ + ] Finished!!!!"

