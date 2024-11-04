# Use a base Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy the Python script into the container
COPY ./Python-Consumer/consumer.py ./
COPY ./Python-Consumer/requirements.txt ./
COPY ./.env ./

# Install required Python libraries
RUN pip install --no-cache-dir -r requirements.txt

# Run the consumer
CMD ["python", "consumer.py"]