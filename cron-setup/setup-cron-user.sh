#!/bin/bash

# ===========================
# Script: setup-cron-user.sh
# Purpose: Add a cron job to the current user's crontab
# This version works for a single user and doesn’t require root permissions. 
# Each user has their own cron table.
# ===========================

# make script executable if needed
# chmod +x setup-cron.sh

# Variables
USER_NAME="youruser" # replace with real username.
SCRIPT_PATH="/home/$USER_NAME/hotel-scraper/scraper.php"
LOG_PATH="/home/$USER_NAME/hotel-scraper/log.txt"

# Cron schedule syntax:
# -*minute (0 - 59)
# -*hour (0 - 23)
# -*day of month (1 - 31)
# -*month (1 - 12)
# -*day of week (0 - 6) (Sunday=0 or 7)
# * * * * * command to execute
#
# "*/30 * * * *" means: every 30 minutes, any hour, any day
CRON_SCHEDULE="*/30 * * * *"

# Build cron job line
CRON_JOB="$CRON_SCHEDULE php $SCRIPT_PATH >> $LOG_PATH 2>&1"

# Check if the job is already in the user’s crontab
# - crontab -l lists the user’s current jobs
# - 2>/dev/null hides the "no crontab for user" error if none exists
# - grep -F searches for the script path
(crontab -l 2>/dev/null | grep -F "$SCRIPT_PATH") >/dev/null
if [ $? -eq 0 ]; then
    echo "Cron job already exists, skipping."
else
    # Append the new job to the crontab
    # - First part: crontab -l (existing jobs, if any)
    # - Second part: echo the job
    # - Combine both and pipe into crontab -
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cron job added successfully:"
    echo "$CRON_JOB"
fi
