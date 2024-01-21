#!/bin/bash

# Function to check if a port is in use and list processes
# Also includes handling for both macOS and Linux
check_and_kill() {
    local port=$1
    echo "Checking for processes on port $port"
    local pids=$(sudo lsof -ti tcp:$port)

    if [ ! -z "$pids" ]; then
        echo "Processes on port $port:"
        sudo lsof -i tcp:$port

        read -p "Do you want to kill these processes? (y/n) " choice
        if [ "$choice" = "y" ]; then
            echo "Killing processes on port $port"
            if [ "$port" -eq 11434 ]; then
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    # Use specific start/stop commands for Linux
                    # Replace with actual service management commands if available
                    sudo service ollama stop
                    sudo service ollama start
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    # Use specific start/stop commands for macOS
                    sudo launchctl stop ollama
                    sudo launchctl start ollama
                fi
            else
                # For other ports, use kill command
                if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
                    sudo kill -9 $pids
                fi
            fi
        else
            echo "Skipping port $port"
        fi
    else
        echo "No processes on port $port"
    fi
}

# Main - Check and kill processes on multiple ports
ports=(11434 3500 3501 3502) # Add more ports as needed
for port in "${ports[@]}"; do
    check_and_kill $port
done
