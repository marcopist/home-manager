#!/usr/bin/env bash

# Waybar auto-hide script based on mouse position
# Shows waybar when mouse is near top, hides otherwise

THRESHOLD=50  # Distance from top to trigger show
HIDDEN=false
CHECK_INTERVAL=0.5

while true; do
    # Get mouse position
    mouse_y=$(hyprctl cursorpos | awk -F',' '{print $2}' | tr -d ' ')

    # Check if mouse is near top
    if [ "$mouse_y" -lt "$THRESHOLD" ]; then
        # Mouse is near top, show waybar
        if [ "$HIDDEN" = true ]; then
            hyprctl keyword layerrule unignore waybar 2>/dev/null
            HIDDEN=false
        fi
    else
        # Mouse is away from top, hide waybar
        if [ "$HIDDEN" = false ]; then
            hyprctl keyword layerrule ignorealpha 0.99 waybar 2>/dev/null
            HIDDEN=true
        fi
    fi

    sleep "$CHECK_INTERVAL"
done
