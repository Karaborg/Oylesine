from kafka import KafkaConsumer
from influxdb import InfluxDBClient
import json
import os
import time
from dotenv import load_dotenv

load_dotenv()

# Kafka settings
KAFKA_BROKER = 'broker:9092'
TOPIC = os.getenv("FIXER_TOPIC_NAME")

# InfluxDB settings
INFLUXDB_HOST = 'influxdb'
INFLUXDB_PORT = 8086
INFLUXDB_DB_NAME = os.getenv("INFLUXDB_DB_NAME")
INFLUXDB_MEASUREMENT_NAME = os.getenv("INFLUXDB_MEASUREMENT_NAME")

# Initialize the counter for unique IDs
id = 0

def consume_and_insert():
    global id  # Use the global counter

    consumer = KafkaConsumer(
        TOPIC,
        bootstrap_servers=[KAFKA_BROKER],
        value_deserializer=lambda m: json.loads(m.decode('utf-8'))
    )

    # Create and configure InfluxDB client
    influx_client = InfluxDBClient(host=INFLUXDB_HOST, port=INFLUXDB_PORT)
    influx_client.create_database(INFLUXDB_DB_NAME)
    influx_client.switch_database(INFLUXDB_DB_NAME)

    for message in consumer:
        try:
            data = message.value  # Get the Kafka message as a Python dictionary
            timestamp = data.get("timestamp")  # Use the timestamp from the message
            rates = data.get("rates")  # Currency rates
            
            if not timestamp or not rates:
                print(f"Invalid message, missing 'timestamp' or 'rates': {data}")
                continue

            # Prepare InfluxDB data structure for each currency
            json_bodies = []

            for currency_code, rate in rates.items():
                json_bodies.append(
                    {
                        "measurement": INFLUXDB_MEASUREMENT_NAME,
                        "tags": {
                            "id": float(id),  # Use the incrementing ID counter
                            "currency": currency_code  # Store the currency code as a tag
                        },
                        #"time": timestamp,  # Use the timestamp from the message
                        "fields": {
                            "rate": float(rate),  # Store the currency rate as a field
                            "currency": currency_code
                        }
                    }
                )

                # Increment the counter for the next currency
                id += 1

            # Write the data to InfluxDB
            influx_client.write_points(json_bodies)
            print(f"Inserted message with id {id-1}, timestamp {timestamp} into InfluxDB.")
        
        except Exception as e:
            print(f"Error processing message: {e}")
            continue

if __name__ == "__main__":
    consume_and_insert()
