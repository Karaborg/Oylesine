# Use a base Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy application files
COPY ./Python-Error-Producer/pushMessage.py ./Python-Error-Producer/requirements.txt ./Kafka/waitForKafka.py ./.env ./

# Install required Python libraries
RUN pip install --no-cache-dir -r requirements.txt

# Ensure the log file is pre-created and has correct permissions
RUN touch producer-output.log && chmod 666 producer-output.log

# Run the consumer, redirecting both stdout and stderr to the log
CMD ["bash", "-c", "python waitForKafka.py && python -u pushMessage.py >> producer-output.log 2>&1"]
