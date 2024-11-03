from kafka import KafkaConsumer
from influxdb import InfluxDBClient
from dotenv import load_dotenv
import json
import os

load_dotenv()

# Kafka settings
KAFKA_BROKER = 'broker:9092'
TOPIC = os.getenv("TOPIC_NAME")
CONSUMER_GROUP_ID = os.getenv("CONSUMER_GROUP_ID", "consumer_group")

# InfluxDB settings
INFLUXDB_HOST = 'influxdb'
INFLUXDB_PORT = 8086
INFLUXDB_DB = os.getenv("DATABASE_NAME")

def consume_and_insert():
    consumer = KafkaConsumer(
        bootstrap_servers=[KAFKA_BROKER],
        group_id=CONSUMER_GROUP_ID,
        value_deserializer=lambda m: json.loads(m.decode('utf-8')),
        enable_auto_commit=True,
        auto_offset_reset='earliest'
    )
    consumer.subscribe([TOPIC])  # Explicitly subscribe to the topic

    influx_client = InfluxDBClient(host=INFLUXDB_HOST, port=INFLUXDB_PORT, database=INFLUXDB_DB)

    for message in consumer:
        data = message.value
        json_body = [
            {
                "measurement": "your_measurement",
                "tags": {
                    "tag_key": "tag_value"
                },
                "fields": data
            }
        ]
        influx_client.write_points(json_body)
        print(f"Inserted message: {data}")

