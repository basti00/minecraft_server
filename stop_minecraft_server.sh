#!/bin/bash
# Script to stop the Minecraft server

# Find the PID of the Minecraft server process
PID=$(ps aux | grep '[j]ava -Xmx3G -Xms3G -jar server.jar nogui' | awk '{print $2}')

if [ -z "$PID" ]; then
    echo "Minecraft server is not running."
else
    echo "Stopping Minecraft server (PID: $PID)..."
    kill -SIGTERM "$PID"
    echo "Minecraft server stopped."
fi
