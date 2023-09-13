#!/usr/bin/env: bash
apt update && apt upgrade -y
apt -y install openssh-client openssh-server
# Active L'authentification 
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
service ssh start
systemd restart sshd
# Mettre à jour le fichier hosts pour les 3 nœuds avec l'adresse IP fournie dans le fichier Vagrantfile
echo -e "192.168.10.3 controller.anslab.com controller\n192.168.10.4 managed1.anslab.com managed1\n192.168.10.5 managed2.anslab.com managed2" >> /etc/hosts
# Installation des paquets nécessaires
apt update && apt -y install curl wget net-tools iputils-ping python3-pip sshpass
# Installer Ansible en utilisant pip uniquement sur le noeud "controller"
if [[ $(hostname) = "controller" ]]; then
pip3 install ansible
fi