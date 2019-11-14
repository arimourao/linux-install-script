#!/bin/bash

#apt packages
sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade
sudo apt-get snapd git vim neovim xclip wget curl -y

#chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb |
sudo dpkg -i google-chrome-stable_current_amd64.deb

#firefox
wget -O FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
sudo mkdir /opt/firefox
tar xjf FirefoxSetup.tar.bz2 -C /opt/firefox/
mv /usr/lib/firefox-esr/firefox-esr /usr/lib/firefox-esr/firefox-esr_orig
ln -s /opt/firefox/firefox/firefox /usr/lib/firefox-esr/firefox-esr

#docker
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
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

#generate ssh key
echo -e "\n\n" | ssh-keygen -t rsa -b 4096 -C "amlima@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

#copy ssh pubkey to clipboard
xclip -sel clip < ~/.ssh/id_rsa.pub

source ~/.bashrc

