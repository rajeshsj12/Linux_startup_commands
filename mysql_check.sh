#!/bin/bash

# Function to check MySQL status
check_mysql() {
    sudo systemctl status mysql.service
}

# Function to start MySQL
start_mysql() {
    sudo systemctl start mysql.service
}

# Function to stop MySQL
stop_mysql() {
    sudo systemctl stop mysql.service
}

# Function to fix MySQL if it fails
fix_mysql() {
    echo "Unmasking MySQL..."
    sudo systemctl unmask mysql.service

    echo "Enabling MySQL..."
    sudo systemctl enable mysql.service

    echo "Restarting MySQL..."
    sudo systemctl restart mysql.service

    echo "Checking MySQL status..."
    check_mysql
}

# Menu to choose the action
echo "Choose an option:"
echo "1. Check MySQL Status"
echo "2. Start MySQL"
echo "3. Stop MySQL"
echo "4. Fix MySQL"
read -p "Enter your choice: " choice

case $choice in
    1) check_mysql ;;
    2) start_mysql ;;
    3) stop_mysql ;;
    4) fix_mysql ;;
    *) echo "Invalid option. Exiting." ;;
esac

