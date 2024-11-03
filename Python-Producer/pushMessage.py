from kafka import KafkaProducer
import json
import time
import os
import random
from dotenv import load_dotenv

load_dotenv()

# Kafka broker address
bootstrap_servers = 'broker:9092'

# Kafka topic
topic = os.getenv("TOPIC_NAME")

# Get the max partition number from the environment file
max_partition = int(os.getenv("PARTITION_COUNT", 0))  # Default to 5 if not set in .env
min_partition = 0  # Assuming partition range starts from 0

# Create Kafka producer
producer = KafkaProducer(
    bootstrap_servers=bootstrap_servers,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

i = 0

try:
    # Send messages continuously
    while True:
        data = {
            "id": i,
            "timestamp": time.time(),
            "tester": "furkan"
        }
        # Get a random partition within the specified range
        partition = random.randint(min_partition, max_partition)
        
        # Send the message to the selected partition
        producer.send(topic, value=data, partition=partition)
        print(f"Sent to partition {partition}: {data}")
        i += 1
        time.sleep(1)  # Adjust the sleep time as needed
except KeyboardInterrupt:
    print("Stopping the producer.")
finally:
    # Flush producer buffer
    producer.flush()