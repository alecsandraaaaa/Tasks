#!/bin/bash

# Function to print home directory
print_home_directory() {
    echo "1. Home Directory:"
    grep "^$1:" /etc/passwd | cut -d: -f6
}

# Function to list all usernames
list_all_usernames() {
    echo "2. List of all usernames:"
    cut -d: -f1 /etc/passwd
}

# Function to count the number of users
count_users() {
    echo "3. Number of users:"
    wc -l < /etc/passwd
}

# Function to find home directory of a specific user
find_user_home_directory() {
    read -p "4. Enter username: " username
    echo "Home directory of $username:"
    print_home_directory $username
}

# Function to list users with specific UID range
list_users_by_uid_range() {
    read -p "5. Enter UID range (e.g. 1000-1010): " uid_range
    echo "Users with UID in range $uid_range:"
    awk -v uid_range="$uid_range" -F: '$3 >= (split(uid_range, a, "-")[1]) && $3 <= (split(uid_range, a, "-")[2]) {print $1}' /etc/passwd
}

# Function to find users with standard shells
find_users_with_standard_shells() {
    echo "6. Users with standard shells (/bin/bash or /bin/sh):"
    grep -E '/bin/(bash|sh)$' /etc/passwd | cut -d: -f1
}

# Function to replace "/" with "\" and redirect to a new file
replace_slash_and_redirect() {
    echo "7. Replacing '/' with '\' in /etc/passwd and redirecting to new file."
    sed 's/\//\\/g' /etc/passwd > /etc/passwd_new
}

# Function to print private IP
print_private_ip() {
    echo "8. Private IP:"
    ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1
}

# Function to print public IP
print_public_ip() {
    echo "9. Public IP:"
    curl -s ifconfig.me
}

# Function to switch to the john user and print home directory
switch_to_john_user() {
    echo "10. Switching to john user and printing home directory:"
    su - john -c 'echo $HOME'
}

# Bonus: Error handling
check_privileges() {
    if [ "$EUID" -ne 0 ]; then
        echo "Error: This script requires root privileges. Please run with sudo."
        exit 1
    fi
}

# Main script
check_privileges

print_home_directory root
list_all_usernames
count_users
find_user_home_directory
list_users_by_uid_range
find_users_with_standard_shells
replace_slash_and_redirect
print_private_ip
print_public_ip
switch_to_john_user
