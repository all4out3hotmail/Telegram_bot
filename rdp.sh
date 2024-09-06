#!/bin/bash

# Update the system
sudo apt update -y && sudo apt upgrade -y

# Remove any previously downloaded incomplete files
rm -f nomachine*.deb

# Download the latest NoMachine package
wget https://download.nomachine.com/download/7.10/Linux/nomachine_7.10.1_1_amd64.deb -O nomachine_latest.deb

# Check if the download was successful
if [ ! -f "nomachine_latest.deb" ]; then
    echo "Failed to download NoMachine package!"
    exit 1
fi

# Install NoMachine
sudo dpkg -i nomachine_latest.deb

# Check if NoMachine installed successfully
if ! command -v /usr/NX/bin/nxserver &> /dev/null
then
    echo "NoMachine installation failed!"
    exit 1
fi

# Modify NoMachine config to run on port 400
sudo sed -i 's/Port 4000/Port 400/' /usr/NX/etc/server.cfg
sudo /usr/NX/bin/nxserver --restart

# Install MATE desktop
sudo apt install mate-desktop-environment -y

# Install ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/local/bin/

# Add your ngrok authtoken directly
ngrok authtoken 2kVmQkatiPOKKYbiZDf4XxwNxTZ_2MhMzm1DyKDEJEaeFsck8

# Run ngrok to expose port 400 (for NoMachine)
echo "Starting ngrok to expose port 400..."
nohup ngrok tcp 400 &

# Output the public URL for accessing NoMachine
sleep 5
curl --silent http://127.0.0.1:4040/api/tunnels | grep -o 'tcp://[^"]*'

echo "NoMachine is running on port 400 and is accessible worldwide via ngrok."
