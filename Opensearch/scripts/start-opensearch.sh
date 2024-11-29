#!/bin/bash

# Remove Plugins
opensearch-plugin remove opensearch-security-analytics
opensearch-plugin remove opensearch-security
opensearch-plugin install https://github.com/aiven/prometheus-exporter-plugin-for-opensearch/releases/download/2.17.1.0/prometheus-exporter-2.17.1.0.zip

# Start Opensearch
opensearch