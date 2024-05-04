#!/bin/bash

# Function to display error messages
function error() {
    echo "Error: $1" >&2
    exit 1
}

# Get the local IP address
ip_address=$(ip addr show | awk '/inet .*brd/ {print $2}')
if [ -z "$ip_address" ]; then
    error "Failed to retrieve IP address"
fi

# Function to generate or retrieve a unique ID
function get_id() {
  if [ ! -f "uuid.json" ]; then
    # Create a new UUID if file doesn't exist
    id=$(uuidgen)
    if [ -z "$id" ]; then
        error "Failed to generate UUID"
    fi
    echo "$id" > uuid.json || error "Failed to write UUID to file"
  else
    # Read the ID from the file
    id=$(cat uuid.json)
    if [ -z "$id" ]; then
        error "Failed to read UUID from file"
    fi
  fi
  echo "$id"
}

# Get the unique ID
id=$(get_id)

# Define the server URL (replace with your actual URL)
server_url="http://192.168.29.58:3000/api/inventory"

# Send a POST request with the IP and ID
response=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"address\": \"$ip_address\", \"id\": \"$id\"}" "$server_url")
if [ $? -ne 0 ]; then
    error "Failed to send POST request to server"
fi

echo "POST request successful. Response: $response"
