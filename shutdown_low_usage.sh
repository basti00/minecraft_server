#!/bin/bash

# Your bot token obtained from the BotFather
BOT_TOKEN="7134072097:AAHMvRoz0gW9-XtEB0Q9Gx6oYWOdnojh9e8"
# The chat ID where you want to send the message
CHAT_ID="-4130647710"

# Threshold for CPU usage (in percentage)
threshold=20

cpu_usage_1m=$(uptime | awk -F'[: ,]+' '{printf "%.0f\n", $12 * 100}')
cpu_usage_5m=$(uptime | awk -F'[: ,]+' '{printf "%.0f\n", $13 * 100}')
cpu_usage_15m=$(uptime | awk -F'[: ,]+' '{printf "%.0f\n", $14 * 100}')

msg=$(uptime)
echo $msg
# curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=$msg" | tee -a ~/ip_telegram.log
echo ""

# Compare CPU usage with threshold
if [ "$cpu_usage_1m" -lt "$threshold" ] && [ "$cpu_usage_5m" -lt "$threshold" ]; then
    if ss -o state established '( dport = :ssh or sport = :ssh )' | grep -q ssh; then
        ssh_active=1
    else
        ssh_active=0
    fi

    uptime_response=$(uptime)
    msg1="Shutting down, $(uptime -p), load below ${threshold}% limit, "
    msg2="averages: 1 min ${cpu_usage_1m}%, 5 min ${cpu_usage_5m}%, 15 min ${cpu_usage_15m}%, SSH: ${ssh_active}"
    echo $msg1$msg2
    curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=$msg1$msg2" | tee -a ~/ip_telegram.log
    echo "" | tee -a ~/ip_telegram.log # append a newline to the log file
    echo ""
    sleep 1
    if [ $ssh_active -eq 0 ]; then
        sudo shutdown -h now
    fi
fi
