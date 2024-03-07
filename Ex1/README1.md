
# Exercise 1: /etc/passwd file manipulation

  This set of commands demonstrates how to create and interact with a Docker container running Ubuntu. The goal is to perform various operations inside the container, such as adding a new user, copying scripts, and executing them.
  ## Prerequisites:
  Docker Desktop is installed on your machine.
 


## Steps

1. Navigate to the Project Directory:

```bash
  cd Desktop\Tremend
```
This command changes the current directory to the project directory.


2. Pull the Latest Ubuntu Image:

```bash
  docker pull ubuntu:latest
```
This command downloads the latest Ubuntu image from Docker Hub.

3. Create and Start the Docker Container:

```bash
  docker run -it --name my_linux_container ubuntu:latest
```
This command creates and starts a new Docker container named my_linux_container based on the Ubuntu image.

4. Start the Existing Container:

```bash
 docker start my_linux_container
```
As I encountered problems with starting the Linux container, due to the fact that I have previously created and stopped the container by mistake.

5. Enter the Container's Shell:
```bash
docker exec -it my_linux_container /bin/bash
```
This command enters the shell of the running container, allowing you to execute commands inside it.

6. Add a New User 'john':
```bash
adduser john
```
This command adds a new user named john to the container. After running this command some information were required: Full name, Room number, Work phone and Home phone.

7. Check User ID and Group ID of 'john':
```bash
id john
```
To make sure that the user 'john' was added in the container I used the 'id' command that returned the user ID and group ID.
For example, if the "adduser john" command encounters an issue during the user creation process (e.g., due to a syntax error, insufficient permissions, or other reasons), it may output an error message indicating the problem.
```bash 
$ id john
id: ‘john’: no such user
```
8. Copy Script into the Container:
```bash
docker cp create_large_file.sh my_linux_container:/home/john
```
This command copies the given script 'create_large_file.sh' into the home directory of the container.


9.  Run the script:
```bash
./create_large_file.sh
```
The script creates a large file filled with null bytes (50 megabytes in size) using 'dd' and then moves this file to the "/home/john" directory using 'mv'.

10. Copy Script into the Container:
```bash
docker cp script.sh my_linux_container:/home
```
This command copies the written script 'script.sh' into the home directory of the container.
The 'script.sh' script contain functions that do the following actions:

1.Print the home directory

2.List all usernames from the passwd file

3.Count the number of users
4.Find the home directory of a specific user (prompt to enter the username value)

5.List users with specific UID range (e.g. 1000-1010)

6.Find users with standard shells like /bin/bash or /bin/sh

7.Replace the “/” character with “\” character in the entire /etc/passwd file and redirect the content to a new file

8.Print the private IP

9.Print the public IP

10.Switch to john user

11.Print the home directory

```bash
#!/bin/bash

# home directory
print_home_directory() {
    echo "1. Home Directory:"
    grep "^$1:" /etc/passwd | cut -d: -f6
}

# list all usernames
list_all_usernames() {
    echo "2. List of all usernames:"
    cut -d: -f1 /etc/passwd
}

#  count the number of users
count_users() {
    echo "3. Number of users:"
    wc -l < /etc/passwd
}

#  find home directory of a specific user
find_user_home_directory() {
    read -p "4. Enter username: " username
    echo "Home directory of $username:"
    print_home_directory $username
}

#  list users with specific UID range
list_users_by_uid_range() {
    read -p "5. Enter UID range (e.g. 1000-1010): " uid_range
    echo "Users with UID in range $uid_range:"
    awk -v uid_range="$uid_range" -F: '$3 >= (split(uid_range, a, "-")[1]) && $3 <= (split(uid_range, a, "-")[2]) {print $1}' /etc/passwd
}

# find users with standard shells
find_users_with_standard_shells() {
    echo "6. Users with standard shells (/bin/bash or /bin/sh):"
    grep -E '/bin/(bash|sh)$' /etc/passwd | cut -d: -f1
}

#replace "/" with "\" and redirect to a new file
replace_slash_and_redirect() {
    echo "7. Replacing '/' with '\' in /etc/passwd and redirecting to new file."
    sed 's/\//\\/g' /etc/passwd > /etc/passwd_new
}

# print private IP
print_private_ip() {
    echo "8. Private IP:"
    ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1
}

#print public IP
print_public_ip() {
    echo "9. Public IP:"
    curl -s ifconfig.me
}

# switch to the john user and print home directory
switch_to_john_user() {
    echo "10. Switching to john user and printing home directory:"
    su - john -c 'echo $HOME'
}

# error handling
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

```
11. Enter the Container's Shell Again and Navigate to the Home Directory:
```bash
docker exec -it my_linux_container /bin/bash
cd /home
```

12. Make 'script.sh' Executable and Fix Line Endings:
```bash
chmod +x script.sh
tr -d '\r' < script.sh > script_fixed.sh
chmod +x script_fixed.sh
```
I used the command 'tr -d '\r' < script.sh > script_fixed.sh' because if I only used './script.sh' an error would have occured.
The error message 'bash: ./script.sh: /bin/bash^M: bad interpreter: No such file or directory' indicates an issue with the shebang line in the script and is related to incorrect line endings.

The '^M' at the end of the error message represents the carriage return character (\r), which is a Windows-style line ending. This character is causing the problem when the script is executed in a Unix-like environment.

The 'chmod +x script_fixed.sh' command is used to make a file executable.

13. Run the Fixed Script:
```bash
./script_fixed.sh
```