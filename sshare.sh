#!/bin/bash

# Exit immediately if a command fails
set -e

echo "--- 1. Updating System ---"
sudo apt update && sudo apt upgrade -y

echo "--- 2. Installing and Configuring SSH ---"
sudo apt install openssh-server -y
sudo systemctl enable --now ssh
sudo systemctl status ssh --no-pager

echo "--- 3. Installing Samba and Nautilus Share ---"
sudo apt install samba nautilus-share -y
# $(whoami) will use the username of the person running the script
sudo usermod -aG sambashare $(whoami)
sudo systemctl restart smbd

echo "--- 4. Configuring Firewall (UFW) ---"
sudo ufw allow ssh
sudo ufw allow 22/tcp
sudo ufw allow samba
sudo ufw allow 8000
# The --force flag skips the "are you sure?" prompt when enabling UFW
sudo ufw --force enable
sudo ufw reload
sudo ufw status verbose

echo "--------------------------------------------------------"
echo "SETUP ALMOST COMPLETE!"
echo "--------------------------------------------------------"
echo "To finish up, you need to do two manual steps:"
echo "1. Create your Samba password by running: sudo smbpasswd -a $(whoami)"
echo "2. Reboot your PC so the user group changes take effect."
