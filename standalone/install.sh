#!/usr/bin/env sh

# Install porkcron as a standalone executable script
cd "$(dirname "$0")"
cp ../porkcron.sh /usr/local/bin/porkcron
chmod +x /usr/local/bin/porkcron

mkdir -p /etc/porkcron
cp ../porkcron.py /etc/porkcron/porkcron.py
chmod +x /etc/porkcron/porkcron.py

# Add a cron entry for it to run on reboot and weekly
echo '@weekly /usr/local/bin/porkcron' > /etc/cron.d/porkcron
echo '@reboot /usr/local/bin/porkcron' >> /etc/cron.d/porkcron

# Run once
/usr/local/bin/porkcron
