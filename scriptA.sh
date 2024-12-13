#!/bin/bash

# Launch a container on a specific CPU core and attach to the custom network
launch_container() {
    # $1 - Container name, $2 - CPU core
    echo "Launching container $1 on CPU core #$2"
    sudo docker run --name "$1" --cpuset-cpus="$2" --network bridge -d miros12/http_server
}

# Terminate a container
terminate_container() {
    # $1 - Container name
    echo "Terminating container $1"
    sudo docker kill "$1"
}

# Check CPU usage for a container
get_cpu_usage() {
    # $1 - Container name
    sudo docker stats --no-stream --format "{{.Name}} {{.CPUPerc}}" | grep "$1" | awk '{print $2}' | sed 's/%//'
}

get_cpu_core() {
    case $1 in
        srv1) echo "0" ;;
        srv2) echo "1" ;;
        srv3) echo "2" ;;
        *) echo "0" ;; # Default core
    esac
}

launch_container() {
    # $1 - Container name, $2 - CPU core
    if sudo docker ps -a --format "{{.Names}}" | grep -q "^$1$"; then
        echo "Container $1 already exists. Removing it..."
        sudo docker rm -f "$1"
    fi
    echo "Launching container $1 on CPU core #$2"
    sudo docker run --name "$1" --cpuset-cpus="$2" --network bridge -d miros12/http_server
}

# Update running containers with a new image
update_containers() {
    echo "Checking for newer image..."
    pull_result=$(sudo docker pull miros12/http_server | grep "Downloaded newer image")
    if [ -n "$pull_result" ]; then
        echo "New image detected. Updating containers..."
        for container in srv1 srv2 srv3; do
            if sudo docker ps --format "{{.Names}}" | grep -q "^$container$"; then
                echo "Updating $container..."
                new_container="${container}_new"
                
                # Launch a new container with a temporary name
                launch_container "$new_container" "$(get_cpu_core "$container")"
                
                # Stop and remove the old container
                terminate_container "$container"
                sudo docker rm "$container"
                
                # Rename the new container to replace the old one
                sudo docker rename "$new_container" "$container"
                echo "$container has been updated."
            fi
        done
    else
        echo "No new image available."
    fi
}

# Main monitoring logic
manage_containers() {
    while true; do
        # Monitor srv1
        if sudo docker ps --format "{{.Names}}" | grep -q "srv1"; then
            cpu_srv1=$(get_cpu_usage "srv1")
            if (( $(echo "$cpu_srv1 > 30.0" | bc -l) )); then
                echo "srv1 is busy. Launching srv2..."
                if ! sudo docker ps --format "{{.Names}}" | grep -q "srv2"; then
                    launch_container "srv2" 1
                fi
            fi
        else
            launch_container "srv1" 0
        fi

        # Monitor srv2
        if sudo docker ps --format "{{.Names}}" | grep -q "srv2"; then
            cpu_srv2=$(get_cpu_usage "srv2")
            if (( $(echo "$cpu_srv2 > 30.0" | bc -l) )); then
                echo "srv2 is busy. Launching srv3..."
                if ! sudo docker ps --format "{{.Names}}" | grep -q "srv3"; then
                    launch_container "srv3" 2
                fi
            fi
        fi

        # Monitor idle containers
        for container in srv3 srv2; do
            if sudo docker ps --format "{{.Names}}" | grep -q "$container"; then
                cpu=$(get_cpu_usage "$container")
                if (( $(echo "$cpu < 1.0" | bc -l) )); then
                    echo "$container is idle. Terminating..."
                    terminate_container "$container"
                fi
            fi
        done

        # Check for updates every 2 minutes
        update_containers
        sleep 120
    done
}

manage_containers
