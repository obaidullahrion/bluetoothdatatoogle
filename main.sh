#!/data/data/com.termux/files/usr/bin/bash









# Log file location
LOG_FILE="/data/data/com.termux/files/home/bluetooth_data_toggle.log"

# Function to turn off data
turn_off_data() {
    echo "[+] Turning off data..." | tee -a $LOG_FILE
    sudo svc data disable && echo "[+] Data turned off successfully." | tee -a $LOG_FILE
    sleep 2
}

# Function to turn on data
turn_on_data() {
    echo "[+] Turning on data..." | tee -a $LOG_FILE
    sudo svc data enable && echo "[+] Data turned on successfully." | tee -a $LOG_FILE
}

# Listen for Bluetooth connection events
echo "[+] Monitoring Bluetooth connection..." | tee -a $LOG_FILE

# Using grep with stricter filtering to ensure only actual connected events are captured
sudo logcat -v time | grep --line-buffered 'android.bluetooth.device.action.ACL_CONNECTED' | while read -r line
do
    # Check if the line contains 'android.bluetooth.device.action.ACL_CONNECTED'
    if echo "$line" | grep -q "android.bluetooth.device.action.ACL_CONNECTED"; then
        # This is a connection event
        echo "[+] Bluetooth device connected: $line" | tee -a $LOG_FILE

        # Turn off and then on data after 1 second and 2 second sleep intervals
        turn_off_data
        turn_on_data
    fi
done
