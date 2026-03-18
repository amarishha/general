#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "--- Starting System Update and Upgrade ---"
sudo apt update && sudo apt upgrade -y

echo "--- Installing and Configuring SSH ---"
sudo apt install openssh-server -y
sudo systemctl enable --now ssh

echo "--- Configuring Firewall (UFW) ---"
sudo ufw allow ssh
sudo ufw allow 22/tcp
sudo ufw allow samba
sudo ufw allow 8000
# Enabling UFW (non-interactive)
echo "y" | sudo ufw enable
sudo ufw status verbose

echo "--- Installing File Sharing Services (Nautilus & Samba) ---"
sudo apt install nautilus-share samba -y

echo "--- Configuring Samba User ---"
# Adding current user to sambashare group
sudo usermod -aG sambashare $USER

echo "--- Finalizing Samba Setup ---"
sudo systemctl restart smbd

echo "--------------------------------------------------------"
echo "SETUP ALMOST COMPLETE"
echo "1. You MUST now set your Samba password manually by running: sudo smbpasswd -a $USER"
echo "2. You MUST reboot your PC for group changes to take effect."
echo "--------------------------------------------------------"
