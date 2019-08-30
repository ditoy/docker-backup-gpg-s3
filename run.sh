#!/bin/sh

# Import GPG public keys
echo "Importing GPG public keys..."
gpg --import /keys/*

# Create and install crontab file
echo "Installing crontab..."
echo "$CRON_INTERVAL /backup.sh" >> /backup.cron

echo "Launching crontab..."
crontab /backup.cron

tail -f /dev/null
