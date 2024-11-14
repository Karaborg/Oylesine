#!/bin/bash

# Check if logstash-output-opensearch plugin installed
if ! bin/logstash-plugin list --verbose | grep -q 'logstash-output-opensearch'; then
    echo 'logstash-output-opensearch plugin not found. Installing...';
    echo 'this will approximately take 5 minutes depending on your machine.'
    bin/logstash-plugin install logstash-output-opensearch;
else
    echo 'logstash-output-opensearch plugin is already installed.';
fi

# Start Logstash
bin/logstash