import os
import socket
import time
from kafka.admin import KafkaAdminClient, NewTopic
from kafka.errors import TopicAlreadyExistsError
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Kafka broker details
KAFKA_HOST = "broker"
KAFKA_PORT = 9092
BROKER_ADDRESS = f"{KAFKA_HOST}:{KAFKA_PORT}"

# Topic details from environment variables
TOPIC_NAME = os.getenv("TOPIC_NAME", "default_topic")
PARTITION_COUNT = int(os.getenv("PARTITION_COUNT", "5"))
REPLICA_COUNT = int(os.getenv("REPLICA_COUNT", "1"))

# Function to check if Kafka broker is ready
def wait_for_kafka():
    while True:
        try:
            with socket.create_connection((KAFKA_HOST, KAFKA_PORT), timeout=5):
                print("Kafka broker is ready.")
                return
        except (socket.timeout, ConnectionRefusedError):
            print("Waiting for Kafka broker to be ready...")
            time.sleep(5)

# Function to create Kafka topic
def create_topic():
    admin_client = KafkaAdminClient(bootstrap_servers=BROKER_ADDRESS)
    topic = NewTopic(name=TOPIC_NAME, num_partitions=PARTITION_COUNT, replication_factor=REPLICA_COUNT)
    
    try:
        admin_client.create_topics(new_topics=[topic], validate_only=False)
        print(f"Topic '{TOPIC_NAME}' created successfully.")
    except TopicAlreadyExistsError:
        print(f"Topic '{TOPIC_NAME}' already exists.")
    finally:
        admin_client.close()

if __name__ == "__main__":
    wait_for_kafka()
    create_topic()