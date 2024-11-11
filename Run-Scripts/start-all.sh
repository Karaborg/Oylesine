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

# Path to the .env file
ENV_FILE="$PROJECT_DIR/.env"

# Check if the .env file exists
if [ -f "$ENV_FILE" ]; then
  echo ".env file already exists at $ENV_FILE. Skipping creation."
else
  echo ".env file does not exist. Let's create it by asking for parameter values."

  # Prompt user for input
  read -p "Enter Grafana Admin Username (default: admin): " GF_SECURITY_ADMIN_USER
  GF_SECURITY_ADMIN_USER=${GF_SECURITY_ADMIN_USER:-admin}

  read -p "Enter Grafana Admin Password: " GF_SECURITY_ADMIN_PASSWORD
  GF_SECURITY_ADMIN_PASSWORD=${GF_SECURITY_ADMIN_PASSWORD}

  read -p "Enter Kafka Topic Name (default: fixer-incoming): " FIXER_TOPIC_NAME
  FIXER_TOPIC_NAME=${FIXER_TOPIC_NAME:-fixer-incoming}

  read -p "Enter InfluxDB Database Name (default: fixer_db): " INFLUXDB_DB_NAME
  INFLUXDB_DB_NAME=${INFLUXDB_DB_NAME:-fixer_db}

  read -p "Enter InfluxDB Measurement Name (default: fixer_table): " INFLUXDB_MEASUREMENT_NAME
  INFLUXDB_MEASUREMENT_NAME=${INFLUXDB_MEASUREMENT_NAME:-fixer_table}

  read -p "Enter Logstash to Kafka Broker Log Topic Name (default: broker-logs): " BROKER_LOG_TOPIC_NAME
  BROKER_LOG_TOPIC_NAME=${BROKER_LOG_TOPIC_NAME:-broker-logs}

  read -p "Enter Logstash to Kafka Zookeeper Log Topic Name (default: zookeeper-logs): " ZOOKEEPER_LOG_TOPIC_NAME
  ZOOKEEPER_LOG_TOPIC_NAME=${ZOOKEEPER_LOG_TOPIC_NAME:-zookeeper-logs}

  read -p "Enter Logstash to Kafka Producer Log Topic Name (default: producer-logs): " PRODUCER_LOG_TOPIC_NAME
  PRODUCER_LOG_TOPIC_NAME=${PRODUCER_LOG_TOPIC_NAME:-producer-logs}

  read -p "Enter Fixer API Key: " API_KEY

  # Create the .env file with the provided inputs
  cat > "$ENV_FILE" <<EOL
# GRAFANA CONFIGURATIONS
GF_SECURITY_ADMIN_USER=$GF_SECURITY_ADMIN_USER
GF_SECURITY_ADMIN_PASSWORD=$GF_SECURITY_ADMIN_PASSWORD

# KAFKA CONFIGURATIONS
FIXER_TOPIC_NAME=$FIXER_TOPIC_NAME
FIXER_PARTITION_COUNT=5
FIXER_REPLICA_COUNT=1
CONSUMER_GROUP_ID=consumerGroup

# INFLUX CONFIGURATIONS
INFLUXDB_DB_NAME=$INFLUXDB_DB_NAME
INFLUXDB_MEASUREMENT_NAME=$INFLUXDB_MEASUREMENT_NAME

# LOGSTASH to KAFKA CONFIGURATIONS
BROKER_LOG_TOPIC_NAME=$BROKER_LOG_TOPIC_NAME
BROKER_LOG_PARTITION_COUNT=3
BROKER_LOG_REPLICA_COUNT=1

ZOOKEEPER_LOG_TOPIC_NAME=$ZOOKEEPER_LOG_TOPIC_NAME
ZOOKEEPER_LOG_PARTITION_COUNT=3
ZOOKEEPER_LOG_REPLICA_COUNT=1

PRODUCER_LOG_TOPIC_NAME=$PRODUCER_LOG_TOPIC_NAME
PRODUCER_LOG_PARTITION_COUNT=3
PRODUCER_LOG_REPLICA_COUNT=1

# FIXER API KEY
API_KEY=$API_KEY
EOL

  echo ".env file created successfully at $ENV_FILE"
fi


# Build and run containers in detached mode
cd $PROJECT_DIR && docker compose up -d --build
