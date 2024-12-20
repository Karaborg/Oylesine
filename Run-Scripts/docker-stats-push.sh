#!/bin/bash

# Pushgateway URL (default to localhost if not set)
PUSHGATEWAY_URL=${PUSHGATEWAY_URL:-http://localhost:9091}

# Function to sanitize and convert units
convert_to_bytes() {
    local value="$1"
    if [[ "$value" == *KiB ]]; then
        echo "$(echo "$value" | sed 's/KiB//' | awk '{printf "%.0f", $1 * 1024}')"
    elif [[ "$value" == *MiB ]]; then
        echo "$(echo "$value" | sed 's/MiB//' | awk '{printf "%.0f", $1 * 1024 * 1024}')"
    elif [[ "$value" == *GiB ]]; then
        echo "$(echo "$value" | sed 's/GiB//' | awk '{printf "%.0f", $1 * 1024 * 1024 * 1024}')"
    elif [[ "$value" == *kB ]]; then
        echo "$(echo "$value" | sed 's/kB//' | awk '{printf "%.0f", $1 * 1000}')"
    elif [[ "$value" == *MB ]]; then
        echo "$(echo "$value" | sed 's/MB//' | awk '{printf "%.0f", $1 * 1000 * 1000}')"
    elif [[ "$value" == *GB ]]; then
        echo "$(echo "$value" | sed 's/GB//' | awk '{printf "%.0f", $1 * 1000 * 1000 * 1000}')"
    else
        echo "$value" | sed 's/B//'
    fi
}

push_metrics() {
    local container_name="$1"
    local cpu_usage="$2"
    local mem_usage="$3"
    local mem_limit="$4"
    local mem_percent="$5"
    local net_rx="$6"
    local net_tx="$7"
    local block_read="$8"
    local block_write="$9"
    local pids="${10}"

    cat <<EOF | curl --data-binary @- ${PUSHGATEWAY_URL}/metrics/job/docker_stats/container/${container_name}
# TYPE container_cpu_usage gauge
container_cpu_usage{name="${container_name}"} ${cpu_usage}
# TYPE container_memory_usage gauge
container_memory_usage{name="${container_name}"} ${mem_usage}
# TYPE container_memory_limit gauge
container_memory_limit{name="${container_name}"} ${mem_limit}
# TYPE container_memory_percent gauge
container_memory_percent{name="${container_name}"} ${mem_percent}
# TYPE container_net_rx gauge
container_net_rx{name="${container_name}"} ${net_rx}
# TYPE container_net_tx gauge
container_net_tx{name="${container_name}"} ${net_tx}
# TYPE container_block_read gauge
container_block_read{name="${container_name}"} ${block_read}
# TYPE container_block_write gauge
container_block_write{name="${container_name}"} ${block_write}
# TYPE container_pids gauge
container_pids{name="${container_name}"} ${pids}
EOF
}

while true; do
    docker stats --no-stream --format "table {{.Name}} {{.CPUPerc}} {{.MemUsage}} {{.NetIO}} {{.BlockIO}} {{.PIDs}}" | tail -n +2 | while read -r line; do
        container_name=$(echo "$line" | awk '{print $1}')
        cpu_usage=$(echo "$line" | awk '{print $2}' | tr -d '%')
        raw_mem_usage=$(echo "$line" | awk '{print $3}' | awk -F'/' '{print $1}')
        raw_mem_limit=$(echo "$line" | awk '{print $3}' | awk -F'/' '{print $2}')
        mem_usage=$(convert_to_bytes "$raw_mem_usage")
        mem_limit=$(convert_to_bytes "$raw_mem_limit")
        mem_percent=$(awk "BEGIN {print ($mem_usage > 0 && $mem_limit > 0) ? ($mem_usage/$mem_limit)*100 : 0}")
        raw_net_rx=$(echo "$line" | awk '{print $4}' | awk -F'/' '{print $1}')
        raw_net_tx=$(echo "$line" | awk '{print $4}' | awk -F'/' '{print $2}')
        net_rx=$(convert_to_bytes "$raw_net_rx")
        net_tx=$(convert_to_bytes "$raw_net_tx")
        block_read=$(convert_to_bytes "$(echo "$line" | awk '{print $5}' | awk -F'/' '{print $1}')")
        block_write=$(convert_to_bytes "$(echo "$line" | awk '{print $5}' | awk -F'/' '{print $2}')")
        pids=$(echo "$line" | awk '{print $6}')

        echo "Container: $container_name, CPU: $cpu_usage, MemUsage: $mem_usage, MemLimit: $mem_limit, MemPercent: $mem_percent, NetIO RX: $net_rx, NetIO TX: $net_tx, BlockIO Read: $block_read, BlockIO Write: $block_write, PIDs: $pids"

        push_metrics "$container_name" "$cpu_usage" "$mem_usage" "$mem_limit" "$mem_percent" "$net_rx" "$net_tx" "$block_read" "$block_write" "$pids"
    done

    sleep 10
done

