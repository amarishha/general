#!/bin/bash

# Ensure the script is run with sudo
if [ -z "$SUDO_USER" ]; then
    echo "ERROR: Please run this script with sudo (e.g., sudo bash script.sh)"
    exit 1
fi

echo "--- 1. Updating System ---"
sudo apt update 

# && sudo apt upgrade -y



echo "--- 2. Installing and Configuring SSH ---"
sudo apt install openssh-server -y
sudo systemctl enable --now ssh
sudo systemctl status ssh --no-pager

echo "--- 3. Installing Samba and Nautilus Share ---"
sudo apt install samba nautilus-share -y
# Uses $SUDO_USER to get the actual person running the sudo command
sudo usermod -aG sambashare "$SUDO_USER"
sudo systemctl restart smbd

echo "--- 4. Configuring Firewall (UFW) ---"
sudo ufw allow ssh
sudo ufw allow 22/tcp
sudo ufw allow samba
sudo ufw allow 8000
# RustDesk Client & Direct IP Connection Ports
sudo ufw allow 21115:21119/tcp
sudo ufw allow 21116/udp
sudo ufw --force enable
sudo ufw reload
sudo ufw status verbose || true

echo "--- 5. Forcing X11 for RustDesk Unattended Access ---"
# Disables Wayland in the GDM3 configuration file add below [daemon] WaylandEnable=false
if [ -f /etc/gdm3/custom.conf ]; then
    sudo sed -i 's/^#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
    echo "Wayland disabled. X11 will be active after the reboot."
else
    echo "Notice: /etc/gdm3/custom.conf not found. You may be using a different display manager."
fi


echo "--------------------------------------------------------"
echo "SETUP ALMOST COMPLETE!"
echo "--------------------------------------------------------"
echo "To finish up, you need to do two manual steps:"
echo "1. Create your Samba password by running: sudo smbpasswd -a $SUDO_USER"
echo "2. Reboot your PC so the user group changes take effect."
