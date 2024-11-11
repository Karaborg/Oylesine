#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Navigate to the main project directory (assumes Run-Scripts is in the main directory)
PROJECT_DIR=$(realpath "$SCRIPT_DIR/..")

# Remove the log files
rm $PROJECT_DIR/App-Logs/*/*.log*

echo "Log files removed successfully in $PROJECT_DIR"
