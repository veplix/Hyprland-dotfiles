#!/usr/bin/env bash

# Notify user that we're scanning for Wi-Fi networks
notify-send "Getting list of available Wi-Fi networks..."

# Get list of available Wi-Fi networks and format it
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

# Check if Wi-Fi is enabled or disabled
connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
    toggle="󰖪  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
    toggle="󰖩  Enable Wi-Fi"
fi

# Display Wi-Fi networks in rofi and let user choose
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: ")

# Extract the SSID from the chosen network
read -r chosen_id <<< "${chosen_network:3}"

# Handle user selection
if [ -z "$chosen_network" ]; then
    exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
    nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
    nmcli radio wifi off
else
    # Success message for successful connection
    success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."

    # Check if the connection is already saved
    saved_connections=$(nmcli -g NAME connection)
    if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
        nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
    else
        # If the network is password-protected, prompt for password with masking
        if [[ "$chosen_network" =~ "" ]]; then
            wifi_password=$(rofi -dmenu -password -p "Password: ")
        fi
        # Attempt to connect to the Wi-Fi network
        nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
    fi
fi