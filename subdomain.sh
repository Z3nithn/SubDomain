#!/bin/zsh

# Function to print in green color
print_green() {
    echo -e "\033[0;32m$1\033[0m"
}

# Function to display a loading animation
loading_animation() {
    local delay=0.1
    local spin='/-\\|'
    
    while true; do
        for i in $(seq 0 3); do
            echo -ne "\r${spin:$i:1} "
            sleep $delay
        done
    done
}

# Function to check and install required tools
check_and_install() {
    for cmd in "$@"; do
        if ! command -v "$cmd" &> /dev/null; then
            print_green "$cmd is not installed. Installing..."
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                sudo apt-get install -y "$cmd" || { echo "Failed to install $cmd"; exit 1; }
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                brew install "$cmd" || { echo "Failed to install $cmd"; exit 1; }
            else
                echo "Unsupported OS. Please install $cmd manually."
                exit 1
            fi
        else
            print_green "$cmd is already installed."
        fi
    done
}

# Function to display an animated figlet header
animated_figlet() {
    local message="$1"
    local delay=0.1

    # Clear the screen
    clear
    for i in $(seq 1 ${#message}); do
        echo -ne "\033[0;32m"
        figlet "${message:0:i}"
        sleep $delay
        clear
    done
    echo -e "\033[0m"  # Reset color
}

# Header
animated_figlet "Subdomain Finder Tool"
print_green " Created by Lalit Jangra"
print_green "=========================================="

# Check if domain name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain-name>"
    exit 1
fi

DOMAIN=$1
OUTPUT_FILE="subdomains.txt"

# Step 1: Create/clear the output file
> "$OUTPUT_FILE"

# Check and install required tools
check_and_install curl jq figlet

# Step 2: Get subdomains from crt.sh
print_green "Fetching subdomains from crt.sh..."
{
    loading_animation &
    LOADING_PID=$!  # Store the loading animation process ID

    curl -s "https://crt.sh/?q=$DOMAIN" | \
    grep -oP "<TD>\K[^<]+" | \
    sort -u >> "$OUTPUT_FILE"

    kill $LOADING_PID  # Kill the loading animation
} 

# Step 3: Use OSINT to find additional subdomains
print_green "Finding additional subdomains using OSINT techniques..."
{
    loading_animation &
    LOADING_PID=$!  # Store the loading animation process ID

    curl -s "https://web.archive.org/cdx/search/cdx?url=*.${DOMAIN}&output=json" | \
    jq -r '.[2:] | .[2]' | sort -u >> "$OUTPUT_FILE"

    kill $LOADING_PID  # Kill the loading animation
} 

# Uncomment below if you have Sublist3r installed and configured
# print_green "Using Sublist3r to find more subdomains..."
# {
#     loading_animation &
#     LOADING_PID=$!  # Store the loading animation process ID
#
#     python3 /path/to/Sublist3r/sublist3r.py -d "$DOMAIN" -o temp.txt
#     cat temp.txt >> "$OUTPUT_FILE"
#
#     kill $LOADING_PID  # Kill the loading animation
# } 

# Step 4: Remove duplicates and provide final list
sort -u "$OUTPUT_FILE" -o "$OUTPUT_FILE"

# Display results
print_green "Subdomains for $DOMAIN:"
cat "$OUTPUT_FILE"

# Optional: Save results to a text file
print_green "Subdomain list saved to $OUTPUT_FILE"
print_green "=========================================="

