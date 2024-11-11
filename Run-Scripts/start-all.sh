#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Navigate to the main project directory (assumes Run-Scripts is in the main directory)
PROJECT_DIR=$(realpath "$SCRIPT_DIR/..")

# Create the necessary directories if they don't exist
mkdir -p "$PROJECT_DIR/App-Logs/Producer"
mkdir -p "$PROJECT_DIR/App-Logs/Error-Producer"

# Create the log files
touch "$PROJECT_DIR/App-Logs/Producer/producer-output.log"
touch "$PROJECT_DIR/App-Logs/Error-Producer/producer-output.log"

echo "Log files created successfully in $PROJECT_DIR"

# Build and run containers in detached mode
cd $PROJECT_DIR && docker compose up -d --build
