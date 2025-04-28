#!/bin/sh

# Install porkcron as a standalone executable script
cd "$(dirname "$0")"
cp ../porkcron.sh /usr/local/bin/porkcron
chmod +x /usr/local/bin/porkcron

mkdir -p /etc/porkcron
cp ../porkcron.py /etc/porkcron/porkcron.py
chmod +x /etc/porkcron/porkcron.py

# Add a cron entries for it to run on reboot and weekly
cp ../crontabs/* /etc/cron.d/

# Run once if the .env file exists
if [ -e ../.env ]
then
  cp ../.env /etc/porkcron/.env
  /usr/local/bin/porkcron
else
  echo "Please fill out the required values for $(dirname "$PWD")/.env.example and copy or move it to /etc/porkcron/.env before running porkcron for the first time."
fi
