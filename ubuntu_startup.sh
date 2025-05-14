#!/bin/bash

echo "Select the components to install (separate numbers with spaces):"
echo "1) System Update & Base Packages"
echo "2) Python Libraries"
echo "3) Virtual Environment Setup"
echo "4) GRUB Customizer"
echo "5) Virtualenvwrapper Configuration"
echo "6) Powerline Terminal Customization"
echo "7) Sudoers Configuration"
echo "8) Enable TRIM for SSDs"
echo "9) Modify Laptop Lid Switch Behavior"
echo "10) Enable UFW Firewall and SSH"
echo "11) Docker User Group"
echo "12) Start Powerline Daemon"
echo "13) System Cleanup"
echo "14) Conda Install"
echo "15) Tor Install"
echo "16) Ubuntu Restricted Extras (Media Codecs)"
echo "17) Preload"
echo "18) Improve Laptop Battery"
echo "19) GNOME Extensions"
echo "20) Papirus Icons"
echo "21) Updates in Snap Store"
echo "22) Install Snap Packages (fallback)"

read -p "Enter numbers: " choices

for choice in $choices; do
    case $choice in
        1) 
            echo "Updating and upgrading the system..."
            sudo apt update && sudo apt upgrade -y
            sudo apt install -y python3 python3-pip python3-venv git wget unzip libfuse2 vlc stacer bleachbit powerline fonts-powerline \
                openjdk-17-jdk htop neofetch curl tree tmux ranger ncdu gnome-tweaks ffmpeg libavcodec-extra \
                ufw openssh-server fail2ban preload docker.io docker-compose synaptic gdebi
            ;;
        2) 
            echo "Installing Python libraries..."
            pip install numpy pandas matplotlib seaborn scikit-learn jupyterlab notebook tensorflow keras xgboost lightgbm \
                opencv-python nltk dask tqdm requests beautifulsoup4 gensim plotly statsmodels django \
                jupyter_contrib_nbextensions jupyterlab_widgets ipywidgets ipdb black flake8 pylint mypy virtualenvwrapper
            ;;
        3) 
            echo "Setting up virtual environment..."
            python3 -m venv /home/$USER/venv
            ;;
        4) 
            echo "Installing GRUB Customizer..."
            if apt show grub-customizer >/dev/null 2>&1; then
                sudo apt update && sudo apt install -y grub-customizer
            else
                echo "GRUB Customizer not available via apt, skipping..."
            fi
            ;;
        5) 
            echo "Configuring Virtualenvwrapper..."
            echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc
            echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc
            ;;
        6) 
            echo "Customizing terminal with Powerline..."
            echo 'if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then source /usr/share/powerline/bindings/bash/powerline.sh; fi' >> ~/.bashrc
            ;;
        7) 
            echo "Configuring sudoers..."
            echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/apt" | sudo tee /etc/sudoers.d/$USER
            ;;
        8) 
            echo "Enabling TRIM for SSDs..."
            sudo systemctl enable fstrim.timer
            ;;
        9) 
            echo "Modifying laptop lid switch behavior..."
            sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
            sudo systemctl restart systemd-logind
            ;;
        10) 
            echo "Enabling UFW firewall and SSH..."
            sudo ufw enable
            sudo systemctl enable ssh
            ;;
        11) 
            echo "Adding user to Docker group..."
            sudo usermod -aG docker $USER
            ;;
        12) 
            echo "Starting Powerline daemon..."
            powerline-daemon --replace
            ;;
        13) 
            echo "Performing system cleanup..."
            sudo apt autoremove -y && sudo apt clean
            ;;
        14) 
            echo "Installing Conda..."
            sudo apt install libgl1-mesa-glx libegl1-mesa libx11-dev libstdc++6 build-essential
            cd ~/Downloads
            bash Anaconda3-<version>-Linux-x86_64.sh -b
            conda config --set auto_activate_base False
            anaconda-navigator
            conda update conda
            conda update anaconda
            conda install anaconda-clean
            anaconda-clean
            ;;
        15) 
            echo "Installing Tor Browser..."
            cd ~/Downloads && tar -xvf BROWSER_FILE_NAME && cd tor-browser && chmod +x start-tor-browser.desktop && ./start-tor-browser.desktop
            ;;
        16) 
            echo "Installing Ubuntu Restricted Extras..."
            sudo apt install ubuntu-restricted-extras -y
            ;;
        17) 
            echo "Installing Preload..."
            sudo apt install preload -y
            ;;
        18) 
            echo "Improving laptop battery performance..."
            sudo apt install tlp tlp-rdw -y
            ;;
        19) 
            echo "Installing GNOME extensions..."
            sudo apt install gnome-browser-connector -y
            ;;
        20) 
            echo "Installing Papirus icon theme..."
            sudo add-apt-repository ppa:papirus/papirus -y
            sudo apt update && sudo apt install papirus-icon-theme -y
            ;;
        21) 
            echo "Refreshing Snap Store..."
            sudo snap refresh snap-store
            sudo snap refresh
            ;;
        22) 
            echo "Installing Snap packages..."
            snap install code discord firefox telegram-desktop vlc thunderbird
            ;;
        *) 
            echo "Invalid option: $choice"
            ;;
    esac
done

echo "Installation complete!"
