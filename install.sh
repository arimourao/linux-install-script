#!/bin/bash

echo "Atualizando lista de pacotes e atualizando-os..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Instalando pacotes necessários para Docker, VirtualBox e outros..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

echo "Adicionando a chave GPG do Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

echo "Adicionando o repositório do Docker..."
echo | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

echo "Adicionando repositório do VirtualBox..."
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
echo | sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

echo "Atualizando pacotes após adicionar novos repositórios..."
sudo apt-get update

echo "Instalando Docker Engine, Docker Compose e VirtualBox..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io virtualbox-6.1

echo "Permitindo o usuário $USER executar Docker sem sudo..."
sudo usermod -aG docker $USER

echo "Instalando Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Instalando e configurando Zsh e Oh My Zsh..."
sudo apt-get install -y zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Instalando e habilitando o servidor SSH..."
sudo apt-get install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

echo "Gerando chaves SSH para o usuário..."
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

echo "Configuração completa!"
