#!/bin/bash

echo "Checking..."
if [[ ! -f "/opt/TelegramApiServer/.env" ]]; then
    echo "The configuration file of TelegramApiServer does not exist, please mount it to \"/opt/TelegramApiServer/.env\""
    exit 0
fi

if [[ ! -f "/opt/TelegramRSS/.env" ]]; then
    echo "The configuration file of TelegramRSS does not exist, please mount it to \"/opt/TelegramRSS/.env\""
    exit 0
fi

cd /opt/TelegramApiServer
echo "Now start TelegramApiServer"
nohup php server.php -e=.env --docker -s=* > /proc/1/fd/1 2>&1 &

cd /opt/TelegramRSS
echo "Now start TelegramRSS"
php server.php -e=.env --session