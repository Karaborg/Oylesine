#!/bin/bash
# wait_for_kafka.sh

KAFKA_HOST="broker"
KAFKA_PORT="9092"

# Wait for Kafka to be ready
while ! nc -z $KAFKA_HOST $KAFKA_PORT; do
  echo "Waiting for Kafka broker to be ready..."
  sleep 5
done

echo "Kafka broker is ready. Creating topic..."
# Place your topic creation command here
kafka-topics --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --create --topic ${TOPIC_NAME} --partitions ${PARTITION_COUNT} --replication-factor ${REPLICA_COUNT}


