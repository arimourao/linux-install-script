#!/bin/bash

#install apt packages
sudo apt-get update
sudo apt-get install git vim neovim snapd xclip wget -y

#chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb |
sudo dpkg -i google-chrome-stable_current_amd64.deb

#firefox
wget -O FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
sudo mkdir /opt/firefox
tar xjf FirefoxSetup.tar.bz2 -C /opt/firefox/
mv /usr/lib/firefox-esr/firefox-esr /usr/lib/firefox-esr/firefox-esr_orig
ln -s /opt/firefox/firefox/firefox /usr/lib/firefox-esr/firefox-esr

#install snapd packages
#sleep 2m
sudo snap install code --classic
sudo snap install emacs --classic
sudo snap install skype --classic
sudo snap install tusk
sudo snap install spotify
sudo snap install telegram-desktop

#generate ssh key
echo -e "\n\n" | ssh-keygen -t rsa -b 4096 -C "amlima@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

#copy ssh key to clipboard
xclip -sel clip < ~/.ssh/id_rsa.pub
