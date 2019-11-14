#!/bin/bash

#apt packages
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y
sudo apt-get snapd git vim neovim xclip wget curl -y

#chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb |
sudo dpkg -i google-chrome-stable_current_amd64.deb

#firefox dev edition
wget "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US" -O firefox-developer.tar.bz2
sudo tar -jxvf  firefox-developer.tar.bz2 -C /opt/
sudo mv /opt/firefox*/ /opt/firefox-developer
sudo ln -sf /opt/firefox-developer/firefox /usr/bin/firefox-developer
echo -e '[Desktop Entry]\n Version=59.0.3\n Encoding=UTF-8\n Name=Mozilla Firefox\n Comment=Navegador Web\n Exec=/opt/firefox-developer/firefox\n Icon=/opt/firefox-developer/browser/chrome/icons/default/default128.png\n Type=Application\n Categories=Network' | sudo tee /usr/share/applications/firefox-developer.desktop

#docker
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     gnupg-agent \
     software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get install docker-ce docker-ce-cli containerd.io

#docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#snapd packages
sudo snap code --classic
sudo snap emacs --classic
sudo snap skype --classic
sudo snap tusk
sudo snap spotify
sudo snap telegram-desktop

#spacemacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

#spacemacs fonts
git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git ~/.fonts/adobe-fonts/source-code-pro
fc-cache -f -v ~/.fonts/adobe-fonts/source-code-pro

#bash-it
git clone --depth=1 https://github.com/arimourao/bash-it.git ~/.bash_it
~/.bash_it/install.sh --silent

#nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

#create sudo rules for my user
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-$USER-for-password

#generate ssh key
echo -e "\n\n" | ssh-keygen -t rsa -b 4096 -C "amlima@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

#copy ssh pubkey to clipboard
xclip -sel clip < ~/.ssh/id_rsa.pub

source ~/.bashrc

