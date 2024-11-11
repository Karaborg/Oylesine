#!/bin/bash

# Create the text file
touch ../App-Logs/Producer/producer-output.log
touch ../App-Logs/Error-Producer/producer-output.log

# Build and run containers in detached mode
docker compose up -d --build
