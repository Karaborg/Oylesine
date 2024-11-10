import os
import socket
import time
from kafka.admin import KafkaAdminClient, NewTopic
from kafka.errors import TopicAlreadyExistsError
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Kafka broker details
KAFKA_HOST = "broker"
KAFKA_PORT = 9092
BROKER_ADDRESS = f"{KAFKA_HOST}:{KAFKA_PORT}"

# Topic details from environment variables (use default if not set)
FIXER_TOPIC_NAME = os.getenv("FIXER_TOPIC_NAME", "fixer-incoming")
FIXER_PARTITION_COUNT = int(os.getenv("FIXER_PARTITION_COUNT", "5"))
FIXER_REPLICA_COUNT = int(os.getenv("FIXER_REPLICA_COUNT", "1"))

BROKER_TOPIC_NAME = os.getenv("BROKER_TOPIC_NAME", "broker-logs")
BROKER_PARTITION_COUNT = int(os.getenv("BROKER_PARTITION_COUNT", "5"))
BROKER_REPLICA_COUNT = int(os.getenv("BROKER_REPLICA_COUNT", "1"))

ZOOKEEPER_TOPIC_NAME = os.getenv("ZOOKEEPER_TOPIC_NAME", "zookeeper-logs")
ZOOKEEPER_PARTITION_COUNT = int(os.getenv("ZOOKEEPER_PARTITION_COUNT", "5"))
ZOOKEEPER_REPLICA_COUNT = int(os.getenv("ZOOKEEPER_REPLICA_COUNT", "1"))

PRODUCER_TOPIC_NAME = os.getenv("PRODUCER_TOPIC_NAME", "producer-logs")
PRODUCER_PARTITION_COUNT = int(os.getenv("PRODUCER_PARTITION_COUNT", "5"))
PRODUCER_REPLICA_COUNT = int(os.getenv("PRODUCER_REPLICA_COUNT", "1"))

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

# Function to create a Kafka topic
def create_topic(topic_name, partition_count, replica_count):
    admin_client = KafkaAdminClient(bootstrap_servers=BROKER_ADDRESS)
    topic = NewTopic(name=topic_name, num_partitions=partition_count, replication_factor=replica_count)

    try:
        print(f"Attempting to create topic: {topic_name} with {partition_count} partitions and {replica_count} replicas.")
        admin_client.create_topics(new_topics=[topic], validate_only=False)
        print(f"Topic '{topic_name}' created successfully.")
    except TopicAlreadyExistsError:
        print(f"Topic '{topic_name}' already exists.")
    except Exception as e:
        print(f"Failed to create topic '{topic_name}': {str(e)}")
    finally:
        admin_client.close()

if __name__ == "__main__":
    # Wait for Kafka to be available before proceeding
    wait_for_kafka()

    # Create the topics
    create_topic(FIXER_TOPIC_NAME, FIXER_PARTITION_COUNT, FIXER_REPLICA_COUNT)
    create_topic(BROKER_TOPIC_NAME, BROKER_PARTITION_COUNT, BROKER_REPLICA_COUNT)
    create_topic(ZOOKEEPER_TOPIC_NAME, ZOOKEEPER_PARTITION_COUNT, ZOOKEEPER_REPLICA_COUNT)
    create_topic(PRODUCER_TOPIC_NAME, PRODUCER_PARTITION_COUNT, PRODUCER_REPLICA_COUNT)
