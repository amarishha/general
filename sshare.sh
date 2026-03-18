#!/bin/bash
set -e

echo "--- Updating System ---"
sudo apt update && sudo apt upgrade -y

echo "--- Installing SSH ---"
sudo apt install openssh-server -y
sudo systemctl enable --now ssh

echo "--- Configuring Firewall ---"
sudo ufw allow ssh
sudo ufw allow 22/tcp
sudo ufw allow 8000

# Try to allow Samba using the profile (Capital S)
# If that fails, it manually opens the Samba ports
sudo ufw allow Samba || {
    echo "Samba profile not found, opening ports manually..."
    sudo ufw allow 137,138/udp
    sudo ufw allow 139,445/tcp
}

echo "y" | sudo ufw enable

echo "--- Installing Samba and Sharing Tools ---"
sudo apt install nautilus-share samba -y
sudo usermod -aG sambashare $USER
sudo systemctl restart smbd

echo "------------------------------------------------"
echo "DONE! Please run this to set your password:"
echo "sudo smbpasswd -a $USER"
echo "Then REBOOT your computer."
echo "------------------------------------------------"
