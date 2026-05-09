#!/bin/bash

# Battery levels to notify at
LOW_BATTERY=20
CRITICAL_BATTERY=10

# File to store the last notified level to avoid spam
STATE_FILE="/tmp/battery_notified"

while true; do
    # Get battery percentage and state (Charging/Discharging)
    BATTERY_INFO=$(upower -i $(upower -e | grep 'battery'))
    PERCENTAGE=$(echo "$BATTERY_INFO" | grep "percentage" | awk '{print $2}' | tr -d '%')
    STATE=$(echo "$BATTERY_INFO" | grep "state" | awk '{print $2}')

    if [ "$STATE" == "discharging" ]; then
        if [ "$PERCENTAGE" -le "$CRITICAL_BATTERY" ]; then
            if [ "$(cat $STATE_FILE 2>/dev/null)" != "critical" ]; then
                notify-send -u critical "Battery Critical" "Battery level is at ${PERCENTAGE}%! Plug in your charger." -i battery-level-10-symbolic
                echo "critical" > "$STATE_FILE"
            fi
        elif [ "$PERCENTAGE" -le "$LOW_BATTERY" ]; then
            if [ "$(cat $STATE_FILE 2>/dev/null)" != "low" ]; then
                notify-send -u normal "Battery Low" "Battery level is at ${PERCENTAGE}%." -i battery-level-20-symbolic
                echo "low" > "$STATE_FILE"
            fi
        fi
    elif [ "$STATE" == "charging" ] || [ "$STATE" == "fully-charged" ]; then
        # Reset state if charging
        rm -f "$STATE_FILE"
    fi

    sleep 60
done
