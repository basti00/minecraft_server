#!/bin/bash
# Add java to path and start minecraft server while writing the output to a log file
export JAVA_HOME=/home/ec2-user/amazon-corretto-23.0.1.8.1-linux-x64/
export PATH=$PATH:$JAVA_HOME/bin

# Start the server with 3GB of RAM, and write the output to a log file
java -Xmx3G -Xms3G -jar server.jar nogui 2>&1 | tee -a ~/minecraft.log