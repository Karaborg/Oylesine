from kafka import KafkaProducer
import json
import time
import os
import random
from dotenv import load_dotenv
import requests

load_dotenv()

DUMMY_API_KEY = os.getenv("DUMMY_API_KEY")
url = f"https://data.fixer.io/api/latest?access_key={DUMMY_API_KEY}"
response = requests.get(url)

if response.status_code == 200:
    data = response.json()  # Parse the response as JSON
    #print(data)  # Print the response data
else:
    print(f"Error: {response.status_code} - {response.text}")

# Kafka broker address
bootstrap_servers = 'broker:9092'

# Kafka topic
topic = os.getenv("FIXER_TOPIC_NAME")

# Get the max partition number from the environment file
max_partition = int(os.getenv("FIXER_PARTITION_COUNT", 0))  # Default to 5 if not set in .env

# Create Kafka producer
producer = KafkaProducer(
    bootstrap_servers=bootstrap_servers,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

i = 0

try:
    # Send messages continuously
    while True:
        # Get a random partition within the specified range
        partition = random.randint(0, (max_partition-1))
        
        # Send the message to the selected partition
        producer.send(topic, value=data, partition=partition)
        print(f"Sent to partition {partition}: {data}")
        i += 1
        time.sleep(1800)  # 14 minutes and 30 seconds.
except KeyboardInterrupt:
    print("Stopping the producer.")
finally:
    # Flush producer buffer
    producer.flush()
