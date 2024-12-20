#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Navigate to the main project directory (assumes Run-Scripts is in the main directory)
PROJECT_DIR=$(realpath "$SCRIPT_DIR/..")

# Stop the monitoring script if it's running
if [ -f $SCRIPT_DIR/docker-stats-push.pid ]; then
    echo "Stopping monitoring script..."
    kill $(cat $SCRIPT_DIR/docker-stats-push.pid) && rm $SCRIPT_DIR/docker-stats-push.pid && rm $PROJECT_DIR/docker-stats-push.log
else
    echo "Monitoring script not running or PID file not found."
fi

# Stop and remove containers, networks, and volumes
cd $PROJECT_DIR && docker compose down -v

echo "Docker project and monitoring script stopped."
