# SubDomain

## Overview
**SubDomain** is a shell script designed to discover subdomains for a specified domain using various OSINT techniques and public resources. The tool features an animated header using `figlet` for a visually appealing user experience.

## Features
- Fetches subdomains from [crt.sh](https://crt.sh)
- Utilizes OSINT techniques to find additional subdomains
- Outputs results in a neatly formatted text file
- Automatically checks for required tools and installs them if missing

## Requirements
- Bash
- `curl`
- `jq`
- `figlet`
- `lolcat` (optional for colorful output)

## Installation
1. Clone the repository:
   ```bash
   git clone https://Z3nithn//SubDomain.git
   cd SubDomain
Make the script executable:

bash
Copy code
chmod +x subdomain.sh
Run the script with a domain name:


./subdomain.sh example.com
Usage
To find subdomains, execute the following command:

./subdomain.sh example.com or bash subdomain.sh example.com
This will fetch subdomains and save them to subdomains.txt.

License
This project is licensed under the MIT License.

Author
Lalit Jangra
Created as part of cybersecurity research.
