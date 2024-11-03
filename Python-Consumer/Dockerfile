# Use a base Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the Python script into the container
COPY ./Python-Consumer/consumer.py ./

COPY ./Python-Producer/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install required Python libraries
RUN pip install kafka-python influxdb

COPY . .

# Run the consumer
CMD ["python", "consumer.py"]
