#!/bin/bash


			#MULTILIB

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Uncomment the [multilib] repository section and the 'Include' line in pacman.conf
sed -i 's/#\[multilib\]/\[multilib\]/' /etc/pacman.conf
sed -i 's/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf

# Synchronize the package databases to include the multilib repository
pacman -Sy


			#PARU INSTALLATION

pacman -Syu --noconfirm
pacman -S --needed base-devel git --noconfirm

git clone https://aur.archlinux.org/paru.git
cd paru || exit

makepkg -si --noconfirm

cd ..


			#GPU DRIVERS

echo "Choose GPU drivers to install:"
echo "1) AMD"
echo "2) NVIDIA"
read -rp "Enter your choice (1 or 2): " choice

install_amd_drivers() {
    echo "Installing AMD drivers..."
    sudo pacman -S --needed --noconfirm xf86-video-amdgpu mesa
    echo "✅ AMD drivers installed!"
}

install_nvidia_drivers() {
    echo "Installing NVIDIA drivers..."
    sudo pacman -S --needed --noconfirm nvidia nvidia-utils nvidia-settings
    echo "✅ NVIDIA drivers installed!"
}

case "$choice" in
    1)
        install_amd_drivers
        ;;
    2)
        install_nvidia_drivers
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac


			#ZSH INSTALLATION
paru -S --needed --noconfirm zsh

# Set Zsh as default shell
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "Setting Zsh as default shell..."
    chsh -s /bin/zsh
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# Configure .zshrc
ZSHRC="$HOME/.zshrc"
if ! grep -q "powerlevel10k/powerlevel10k" "$ZSHRC"; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
fi

if ! grep -q "zsh-autosuggestions" "$ZSHRC"; then
    sed -i 's/^plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC"
fi


			#DEPENDENCIES

paru -S firefox telegram-desktop rofi waybar nemo alacritty grim slurp neovim swaync nerd-fonts hyprlock hyprpaper ttf-jetbrains-mono ttf-fira-code vlc qbittorent wl-clipboard engrampa nwg-look peaclock cava pavucontrol nvtop fastfetch gtk2 gtk3 gtk4 font-manager discord cmake make bibata-cursor-theme-bin 


			#GRUB THEME

cd ./grub/
sudo chmod +x install.sh
sudo ./install.sh -t vimix
cd ./


			#CONFIGS
cp -R ./.config/ /home/$USER/
cp -R ./.themes/ /home/$USER/ 
cp -R ./.icons/ /home/$USER/
cp -R ./.scripts/ /home/$USER/
cp -R ./.oh-my-zsh/ /home/$USER/
cp ./.zshrc /home/$USER/
cp -R ./.qbittorrent-themes/ /home/$USER/
cp -R ./.vlc-skins /home/$USER/
sudo cp -R ./sddm/blueleaf /usr/share/sddm/themes/
