#!/bin/bash

# Pushgateway URL
PUSHGATEWAY_URL=${PUSHGATEWAY_URL:-http://localhost:9091}

# Function to push metrics to Pushgateway
push_metrics() {
    local container_name="$1"
    local cpu_usage="$2"
    local memory_usage="$3"

    # Create and send metrics to Pushgateway
    cat <<EOF | curl --data-binary @- ${PUSHGATEWAY_URL}/metrics/job/docker_stats/container/${container_name}
# TYPE container_cpu_usage gauge
container_cpu_usage{name="${container_name}"} ${cpu_usage}
# TYPE container_memory_usage gauge
container_memory_usage{name="${container_name}"} ${memory_usage}
EOF
}

# Continuous monitoring loop
while true; do
    # Get Docker stats for all containers
    docker stats --no-stream --format "{{.Name}} {{.CPUPerc}} {{.MemUsage}}" | while read -r line; do
        # Parse container name, CPU usage, and memory usage
        container_name=$(echo "$line" | awk '{print $1}')
        cpu_usage=$(echo "$line" | awk '{print $2}' | tr -d '%')
        memory_usage=$(echo "$line" | awk '{print $3}' | awk -F"/" '{print $1}' | tr -d 'MiB')

        # Convert memory usage to megabytes (if needed, depending on output format)
        memory_usage=$(echo "$memory_usage" | awk '{print $1 * 1.0}')

        # Push metrics to Pushgateway
        push_metrics "$container_name" "$cpu_usage" "$memory_usage"
    done

    # Wait for 10 seconds before the next iteration
    sleep 10
done
