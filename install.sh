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
echo " ${GREEN}[ + ]${NC} Installing the following deps: nemo, git, python, python-pip, neovim, dunst, htop, kitty, neofetch, qt6ct, rofi, eza, alacritty, curl, zip, unzip, grim, slurp, qt6-wayland, mpv, xdotool, wf-recorder, cliphist, feh, emacs, sddm polkit polkit-kde-agent, blueman..."

yay -S nemo git python python-pip neovim waybar dunst htop kitty neofetch qt6ct rofi eza alacritty curl zip unzip grim slurp qt6-wayland mpv xdotool wf-recorder cliphist feh emacs sddm polkit polkit-kde-agent blueman

# Install zellig
cargo install --locked zellij

# Installing the Hack nerd font
echo " ${GREEN}[ + ]${NC} Installing the Hack Nerd font..."

echo " ${GREEN}[ + ]${NC} Font url: https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_NAME.zip"
curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_NAME.zip"
echo " ${GREEN}[ + ]${NC} creating fonts folder: ${HOME}/.fonts"
mkdir -p  "$HOME/.fonts"
echo " ${GREEN}[ + ]${NC} unzip the $FONT_NAME.zip"
unzip "$FONT_NAME.zip" -d "$HOME/.fonts/$FONT_NAME/" && rm "./$FONT_NAME.zip"
fc-cache -fv

# Installing oh-my-zsh
echo "${GREEN}[ + ]${NC} Installing oh-my-zsh..."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Installing oh-my-zsh plugins
echo "${GREEN}[ + ]${NC} Installing oh-my-zsh plugins..."

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/

git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Copying config files to $HOME/.config
echo " ${GREEN}[ + ]${NC} Copying config files to $HOME/.config ..."

cp ./configs/* $HOME/.config/ -r

cp .zshrc ~/
cp .p10k.zsh ~/
cp .emacs .emacs.d .emacs.local .emacs.rc .emacs.snippets ~/ -r

cp wallpapers/ ~/.wallpapers/ -r

echo "${GREEN}[ + ]{$NC} Finished!!"

echo "[ ! ] Please run the following command to download the catpuccino sddm theme:\n \$ git clone https://github.com/catppuccin/sddm ./sddm && cp ./sddm/src/catppuccin-macchiato /usr/share/sddm/themes/ && cp ./sddm.conf /etc/sddm.conf && sudo systemctl restart sddm"
