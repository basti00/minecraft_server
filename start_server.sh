#!/bin/bash

# Your bot token obtained from the BotFather
BOT_TOKEN="7134072097:AAHMvRoz0gW9-XtEB0Q9Gx6oYWOdnojh9e8"
# The chat ID where you want to send the message
CHAT_ID="-4130647710"

# re/start nginx server
sudo systemctl restart nginx

cd ~/minecraft_server/
# display stderr and output of server in console, while also appending it to a log file

# Send the public IP address as a message before waiting 15 sec, while also starting the server immediatly
# and running a low usage watchdog to shutdown the server, and periodically update the map
(
    sleep 5
    PUBLIC_IP=$(curl -s icanhazip.com)
    curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=Started with IP Address: $PUBLIC_IP" | tee -a ~/ip_telegram.log
    echo "" | tee -a ~/ip_telegram.log # append a newline to the log file
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
./start_minecraft_server.sh
