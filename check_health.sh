#!/bin/bash

# Function to check if a value exceeds threshold
check_threshold() {
    local value=$1
    local threshold=60
    if (( $(echo "$value >= $threshold" | bc -l) )); then
        return 1
    fi
    return 0
}

# Initialize variables
is_healthy=true
issues=()

# Check CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
if ! check_threshold $cpu_usage; then
    is_healthy=false
    issues+=("CPU usage is high at ${cpu_usage}%")
fi

# Check memory usage
memory_info=$(free | grep Mem)
total_memory=$(echo $memory_info | awk '{print $2}')
used_memory=$(echo $memory_info | awk '{print $3}')
memory_usage=$(echo "scale=2; $used_memory/$total_memory * 100" | bc)
if ! check_threshold $memory_usage; then
    is_healthy=false
    issues+=("Memory usage is high at ${memory_usage}%")
fi

# Check disk usage
while IFS= read -r line; do
    disk_usage=$(echo $line | awk '{print $5}' | sed 's/%//')
    mount_point=$(echo $line | awk '{print $6}')
    if ! check_threshold $disk_usage; then
        is_healthy=false
        issues+=("Disk \"$mount_point\" usage is high at ${disk_usage}%")
    fi
done < <(df -h | grep '^/dev/')

# Print health status
if $is_healthy; then
    echo "VM Health Status: HEALTHY"
else
    echo "VM Health Status: NOT HEALTHY"
fi

# If explain argument is provided
if [[ "$1" == "explain" ]]; then
    if $is_healthy; then
        echo -e "\nAll systems are running within normal parameters:"
        echo "- CPU usage: ${cpu_usage}%"
        echo "- Memory usage: ${memory_usage}%"
        echo "- Disk usage:"
        df -h | grep '^/dev/' | while read -r line; do
            mount_point=$(echo $line | awk '{print $6}')
            usage=$(echo $line | awk '{print $5}')
            echo "  $mount_point: $usage"
        done
    else
        echo -e "\nIssues found:"
        for issue in "${issues[@]}"; do
            echo "- $issue"
        done
    fi
fi