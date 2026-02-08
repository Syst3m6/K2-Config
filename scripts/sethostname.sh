#!/bin/sh

CONFIG="/mnt/UDISK/creality/userdata/config/system_config.json"

echo "Enter new hostname:"
read NEWNAME

if [ -z "$NEWNAME" ]; then
    echo "No hostname entered. Exiting."
    exit 1
fi

echo "Setting hostname to: $NEWNAME"

# ============================================================
# Update /etc/hostname
# ============================================================
echo "$NEWNAME" > /etc/hostname

# ============================================================
# Update /etc/hosts
# ============================================================
# Remove any existing 127.0.1.1 line
sed -i '/^127\.0\.1\.1/d' /etc/hosts

# Add the new one
echo "127.0.1.1   $NEWNAME" >> /etc/hosts

# Apply hostname immediately (if script exists)
if [ -x /etc/init.d/hostname.sh ]; then
    /etc/init.d/hostname.sh start
fi

# ============================================================
# Update system_config.json
# ============================================================
if [ -f "$CONFIG" ]; then
    echo "Updating system_config.json..."

    # Backup
    cp "$CONFIG" "$CONFIG.bak"

    # Update host_name
    sed -i "s/\"host_name\":\"[^\"]*\"/\"host_name\":\"$NEWNAME\"/" "$CONFIG"

    # Update time_zone
    sed -i "s/\"time_zone\":\"[^\"]*\"/\"time_zone\":\"UTC-06:00\"/" "$CONFIG"

    echo "system_config.json updated."
    echo "Backup saved at: $CONFIG.bak"
else
    echo "WARNING: system_config.json not found at $CONFIG"
fi

echo "Done. Reboot recommended."
