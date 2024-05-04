#!/bin/bash

# Get the local IP address
ip_address=$(ip addr show | awk '/inet .*brd/ {print $2}')

# Function to generate or retrieve a unique ID
function get_id() {
  if [ ! -f "uuid.json" ]; then
    # Create a new UUID if file doesn't exist
    id=$(uuidgen)
    echo "{\"id\": \"$id\"}" > uuid.json
  else
    # Read the ID from the file
    id=$(cat uuid.json | jq -r '.id')
  fi
  echo "$id"
}

# Get the unique ID
id=$(get_id)

# Define the server URL (replace with your actual URL)
server_url="http://192.168.29.58:3000/api/inventory"

# Send a POST request with the IP and ID
curl -X POST -H "Content-Type: application/json" -d "{\"address\": \"$ip_address\", \"id\": \"$id\"}" "$server_url"