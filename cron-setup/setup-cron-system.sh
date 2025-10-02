#!/bin/bash

# ===========================
# Script: setup-cron-system.sh
# Purpose: Create a cron job file in /etc/cron.d
# NOTE: This version must be run with sudo/root because /etc/cron.d is system-owned.

# This version is better for system administration, 
# because jobs live in a file (/etc/cron.d/hotel_scraper) 
# instead of being tied to a specific user’s hidden crontab.
# ===========================

# Variables
USER_NAME="youruser" # replace with username to run job as.
SCRIPT_PATH="/home/$USER_NAME/hotel-scraper/scraper.php"
LOG_PATH="/home/$USER_NAME/hotel-scraper/log.txt"
CRON_SCHEDULE="*/30 * * * *"

# File to hold the cron job
CRON_FILE="/etc/cron.d/hotel_scraper"

# Format for /etc/cron.d is slightly different:
# -schedule
# -user the job runs as
# -command
# * * * * *     user command
#
# must include the username explicitly.
CRON_JOB="$CRON_SCHEDULE $USER_NAME php $SCRIPT_PATH >> $LOG_PATH 2>&1"

# Check if file already exists
if [ -f "$CRON_FILE" ]; then
    echo "Cron file already exists at $CRON_FILE, skipping."
else
    # Write the job into the file
    echo "$CRON_JOB" | sudo tee "$CRON_FILE" > /dev/null
    # Set proper permissions
    # Cron requires these files to be readable by root
    sudo chmod 644 "$CRON_FILE"
    echo "System-wide cron job added in $CRON_FILE:"
    echo "$CRON_JOB"
fi

