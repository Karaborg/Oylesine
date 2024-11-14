#!/bin/bash

# Start Kafka Exporter
sleep 15 
/home/appuser/kafka_exporter --kafka.server=broker:9092 --kafka.version=3.3.1 --log.enable-sarama