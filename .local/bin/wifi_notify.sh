#!/bin/bash

# Function to get the SSID of the currently connected wifi
get_ssid() {
    nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2
}

# Monitor NetworkManager events
nmcli monitor | while read -r line; do
    # Filter for wifi device events (usually wlan0)
    if echo "$line" | grep -qE "wlan[0-9]:"; then
        DEVICE=$(echo "$line" | cut -d: -f1)
        
        if echo "$line" | grep -q " disconnected"; then
            notify-send -u normal "WiFi Disconnected" "Connection lost on $DEVICE." -i network-wireless-offline-symbolic
        elif echo "$line" | grep -q " connected"; then
            # Wait a moment for SSID to be available
            sleep 1
            SSID=$(get_ssid)
            notify-send -u low "WiFi Connected" "Connected to ${SSID:-$DEVICE}" -i network-wireless-connected-symbolic
        fi
    fi
done
