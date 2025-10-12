#!/bin/bash

options="  Shutdown\n  Reboot\n  Lock\n  SDDM"

choice=$(echo -e "$options" | rofi -dmenu -i -selected-row 0 -p "Power Menu")

case "$choice" in
    "  Lock") hyprlock ;;
    "  SDDM") hyprctl dispatch exit ;;
    "  Reboot") systemctl reboot ;;
    "  Shutdown") systemctl poweroff ;;
esac

