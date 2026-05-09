#!/bin/bash

# Battery levels to notify at
LOW_BATTERY=20
CRITICAL_BATTERY=10

# Files to store states to avoid spam
STATE_FILE="/tmp/battery_notified"
CHARGER_STATE_FILE="/tmp/charger_state"

# Ensure initial charger state is set without notification on first run?
# No, let's keep it simple.

while true; do
    # Get battery percentage and state
    # Using /sys/class/power_supply for more direct access
    if [ -d /sys/class/power_supply/BAT0 ]; then
        PERCENTAGE=$(cat /sys/class/power_supply/BAT0/capacity)
        BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)
    else
        # Fallback to upower if BAT0 is not there
        BATTERY_INFO=$(upower -i $(upower -e | grep 'battery' | head -n 1))
        PERCENTAGE=$(echo "$BATTERY_INFO" | grep "percentage" | awk '{print $2}' | tr -d '%')
        BAT_STATUS=$(echo "$BATTERY_INFO" | grep "state" | awk '{print $2}')
    fi

    # --- Charger Plug/Unplug Logic ---
    # Check if any power supply (AC, USB-C) is online
    if grep -q 1 /sys/class/power_supply/*/online 2>/dev/null; then
        CURRENT_CHARGER_STATE="plugged"
    else
        CURRENT_CHARGER_STATE="unplugged"
    fi

    LAST_CHARGER_STATE=$(cat "$CHARGER_STATE_FILE" 2>/dev/null)

    if [ -n "$LAST_CHARGER_STATE" ] && [ "$CURRENT_CHARGER_STATE" != "$LAST_CHARGER_STATE" ]; then
        if [ "$CURRENT_CHARGER_STATE" == "plugged" ]; then
            notify-send -u low "Charger Connected" "Battery is now charging (${PERCENTAGE}%)." -i ac-adapter-symbolic
        else
            notify-send -u low "Charger Disconnected" "Running on battery (${PERCENTAGE}%)." -i battery-symbolic
        fi
    fi
    # Save the state even if it's the first run
    echo "$CURRENT_CHARGER_STATE" > "$CHARGER_STATE_FILE"

    # --- Low Battery Logic ---
    if [ "$CURRENT_CHARGER_STATE" == "unplugged" ]; then
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
    else
        # Reset low battery notification state if plugged in
        rm -f "$STATE_FILE"
    fi

    sleep 5
done
