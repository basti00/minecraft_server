#!/bin/bash

# Your bot token obtained from the BotFather
BOT_TOKEN="7134072097:AAHMvRoz0gW9-XtEB0Q9Gx6oYWOdnojh9e8"
# The chat ID where you want to send the message
CHAT_ID="-4130647710"

# re/start nginx server
sudo systemctl restart nginx

# Add java to path and start minecraft server while writing the output to a log file
export JAVA_HOME=/home/ec2-user/amazon-corretto-17.0.7.7.1-linux-x64/
export PATH=$PATH:$JAVA_HOME/bin
cd ~/minecraft_server/
# display stderr and output of server in console, while also appending it to a log file

# Send the public IP address as a message before waiting 15 sec, while also starting the server immediatly
# and running a low usage watchdog to shutdown the server, and periodically update the map
(
    sleep 5
    PUBLIC_IP=$(curl -s icanhazip.com)
    curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=Started with IP Address: $PUBLIC_IP" | tee -a ~/ip_te
) &
(
    sleep 120
    cd ~
    while true; do
        ./shutdown_low_usage.sh
        sleep 120
    done
) &
(
    sleep 30
    while true; do
        ./update_map.sh
        sleep 600
    done
) &
java -Xmx3G -Xms3G -jar server.jar nogui 2>&1 | tee -a ~/minecraft.log
