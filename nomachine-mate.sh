#!/bin/bash

# Disable interrupt signals
stty intr ""
stty quit ""
stty susp undef

# Clear the terminal screen
clear

# Remove any existing ngrok files
rm -rf ngrok ngrok.zip ng.sh > /dev/null 2>&1

# Inform the user about the download
echo "======================="
echo "Downloading ngrok..."
echo "======================="

# Download ngrok
wget -O ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz > /dev/null 2>&1

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download ngrok."
    exit 1
fi

# Extract the downloaded file
tar -xvzf ngrok.tgz > /dev/null 2>&1

# Check if extraction was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract ngrok."
    exit 1
fi

# Proceed with the rest of your script
echo "Ngrok downloaded and extracted successfully."

# Define the goto function
function goto {
    label=$1
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

: ngrok
clear
echo "Go to: https://dashboard.ngrok.com/get-started/your-authtoken"
read -p "Paste Ngrok Authtoken: " CRP
./ngrok config add-authtoken $CRP 

# Clear the screen and ask for ngrok region
clear
echo "Repo: https://github.com/kmille36/Docker-Ubuntu-Desktop-NoMachine"
echo "======================="
echo "Choose ngrok region (for better connection)."
echo "======================="
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "Choose ngrok region: " CRP
./ngrok tcp --region $CRP 4000 &>/dev/null &
sleep 1

# Check if ngrok is running
if curl --silent --show-error http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1; then 
    echo OK
else 
    echo "Ngrok Error! Please try again!" 
    sleep 1 
    goto ngrok
fi

# Run the NoMachine Docker container
docker run --rm -d --network host --privileged --name nomachine-mate -e PASSWORD=2608 -e USER=all4out --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:mate

# Clear the screen and display NoMachine information
clear
echo "NoMachine: https://www.nomachine.com/download"
echo "Done! NoMachine Information:"
echo "IP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p' 
echo "User: all4out"
echo "Passwd: 2608"
echo "VM can't connect? Restart Cloud Shell then re-run the script."

# Show progress
seq 1 43200 | while read i; do 
    echo -en "\r Running .     $i s /43200 s"; sleep 0.1
    echo -en "\r Running ..    $i s /43200 s"; sleep 0.1
    echo -en "\r Running ...   $i s /43200 s"; sleep 0.1
    echo -en "\r Running ....  $i s /43200 s"; sleep 0.1
    echo -en "\r Running ..... $i s /43200 s"; sleep 0.1
    echo -en "\r Running     . $i s /43200 s"; sleep 0.1
    echo -en "\r Running  .... $i s /43200 s"; sleep 0.1
    echo -en "\r Running   ... $i s /43200 s"; sleep 0.1
    echo -en "\r Running    .. $i s /43200 s"; sleep 0.1
    echo -en "\r Running     . $i s /43200 s"; sleep 0.1
done
