from kafka import KafkaConsumer
from influxdb import InfluxDBClient
import json
import os
from dotenv import load_dotenv

load_dotenv()

# Kafka settings
KAFKA_BROKER = 'broker:9092'
TOPIC = os.getenv("TOPIC_NAME")

# InfluxDB settings
INFLUXDB_HOST = 'influxdb'
INFLUXDB_PORT = 8086
INFLUXDB_DB = os.getenv("DATABASE_NAME")

def consume_and_insert():
    consumer = KafkaConsumer(
        TOPIC,
        bootstrap_servers=[KAFKA_BROKER],
        value_deserializer=lambda m: json.loads(m.decode('utf-8'))
    )
    influx_client = InfluxDBClient(host=INFLUXDB_HOST, port=INFLUXDB_PORT, database=INFLUXDB_DB)

    for message in consumer:
        data = message.value  # Assume data is a dictionary
        json_body = [
            {
                "measurement": "your_measurement",
                "tags": {
                    "tag_key": "tag_value"  # Add tags as needed
                },
                "fields": data
            }
        ]
        influx_client.write_points(json_body)
        print(f"Inserted message: {data}")

if __name__ == "__main__":
    consume_and_insert()
