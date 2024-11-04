# Use a base Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy the Python script into the container
COPY ./Python-Producer/pushMessage.py ./
COPY ./Kafka/waitForKafka.py ./
COPY ./Python-Producer/requirements.txt ./
COPY ./.env ./

# Install required Python libraries
RUN pip install --no-cache-dir -r requirements.txt

# Run the consumer
CMD ["bash", "-c", "python waitForKafka.py && python pushMessage.py"]
