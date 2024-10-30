#!/bin/bash

# Função para verificar e instalar pacotes
install_if_not_exists() {
    if ! dpkg -s "$1" &>/dev/null; then
        echo "Instalando $1..."
        sudo apt-get install -y "$1"
    else
        echo "$1 já está instalado."
    fi
}

echo "Atualizando lista de pacotes e atualizando-os..."
sudo apt-get update && sudo apt-get upgrade -y

# Instalação de Git, Vim e Autojump
echo "Instalando Git, Vim e Autojump..."
install_if_not_exists git
install_if_not_exists vim
install_if_not_exists autojump

# Configuração do Autojump para Zsh
echo "Configurando Autojump para funcionar com Zsh..."
if ! grep -q "source /usr/share/autojump/autojump.zsh" ~/.zshrc; then
    echo '[[ -s /usr/share/autojump/autojump.zsh ]] && source /usr/share/autojump/autojump.zsh' >>~/.zshrc
fi

# Docker Setup
echo "Instalando pacotes necessários para Docker, VirtualBox e outros..."
install_if_not_exists apt-transport-https
install_if_not_exists ca-certificates
install_if_not_exists curl
install_if_not_exists gnupg-agent
install_if_not_exists software-properties-common

echo "Adicionando a chave GPG do Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

echo "Adicionando o repositório do Docker..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# VirtualBox Setup
echo "Adicionando repositório do VirtualBox..."
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

# VSCode Setup
echo "Adicionando a chave GPG e o repositório do Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Brave Browser Setup
echo "Adicionando repositório e chave GPG do Brave Browser..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Chrome Canary Setup
echo "Adicionando repositório e chave GPG do Chrome Canary..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

echo "Atualizando pacotes após adicionar novos repositórios..."
sudo apt-get update

echo "Instalando Docker Engine, Docker Compose, VirtualBox, Visual Studio Code, Brave Browser e Chrome Canary..."
install_if_not_exists docker-ce
install_if_not_exists docker-ce-cli
install_if_not_exists containerd.io
install_if_not_exists virtualbox-6.1
install_if_not_exists code
install_if_not_exists brave-browser
install_if_not_exists google-chrome-unstable  # Chrome Canary

echo "Permitindo o usuário $USER executar Docker sem sudo..."
sudo usermod -aG docker $USER

echo "Instalando Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Instalando e configurando Zsh e Oh My Zsh..."
install_if_not_exists zsh
chsh -s $(which zsh)
RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# NVM Setup
echo "Instalando NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Carrega o nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Carrega o nvm bash_completion
echo 'export NVM_DIR="$HOME/.nvm"' >>~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >>~/.zshrc

echo "Instalando e habilitando o servidor SSH..."
install_if_not_exists openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

echo "Gerando chaves SSH para o usuário..."
[ ! -f ~/.ssh/id_rsa ] && ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" || echo "Chave SSH já existe."

echo "Configuração completa!"
