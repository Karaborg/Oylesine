#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Navigate to the main project directory (assumes Run-Scripts is in the main directory)
PROJECT_DIR=$(realpath "$SCRIPT_DIR/..")

# Stop and remove containers, networks, and volumes
cd $PROJECT_DIR && docker compose down -v
