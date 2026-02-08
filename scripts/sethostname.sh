#!/bin/sh

echo "Enter new hostname:"
read NEWNAME

if [ -z "$NEWNAME" ]; then
    echo "No hostname entered. Exiting."
    exit 1
fi

echo "Setting hostname to: $NEWNAME"

# Update /etc/hostname
echo "$NEWNAME" > /etc/hostname

# Update /etc/hosts
# Remove any existing 127.0.1.1 line
sed -i '/^127\.0\.1\.1/d' /etc/hosts

# Add the new one
echo "127.0.1.1   $NEWNAME" >> /etc/hosts

# Apply hostname immediately (if script exists)
if [ -x /etc/init.d/hostname.sh ]; then
    /etc/init.d/hostname.sh start
fi

echo "Done. Reboot recommended."
