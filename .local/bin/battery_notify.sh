#!/bin/bash

# Battery levels to notify at
LOW_BATTERY=20
CRITICAL_BATTERY=10

# Files to store states to avoid spam
STATE_FILE="/tmp/battery_notified"
CHARGER_STATE_FILE="/tmp/charger_state"

while true; do
    # Get battery percentage and state (Charging/Discharging/Full)
    BATTERY_INFO=$(upower -i $(upower -e | grep 'battery'))
    PERCENTAGE=$(echo "$BATTERY_INFO" | grep "percentage" | awk '{print $2}' | tr -d '%')
    STATE=$(echo "$BATTERY_INFO" | grep "state" | awk '{print $2}')

    # --- Charger Plug/Unplug Logic ---
    LAST_CHARGER_STATE=$(cat "$CHARGER_STATE_FILE" 2>/dev/null)

    if [ "$STATE" == "charging" ] || [ "$STATE" == "fully-charged" ]; then
        CURRENT_CHARGER_STATE="plugged"
    else
        CURRENT_CHARGER_STATE="unplugged"
    fi

    if [ "$CURRENT_CHARGER_STATE" != "$LAST_CHARGER_STATE" ]; then
        if [ "$CURRENT_CHARGER_STATE" == "plugged" ]; then
            notify-send -u low "Charger Connected" "Battery is now charging (${PERCENTAGE}%)." -i ac-adapter-symbolic
        else
            notify-send -u low "Charger Disconnected" "Running on battery (${PERCENTAGE}%)." -i battery-symbolic
        fi
        echo "$CURRENT_CHARGER_STATE" > "$CHARGER_STATE_FILE"
    fi

    # --- Low Battery Logic ---
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
        # Reset low battery notification state if charging
        rm -f "$STATE_FILE"
    fi

    sleep 10
done
