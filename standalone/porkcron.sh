#!/bin/sh

# Move to /etc/porkcron
cd /etc/porkcron

# Read the .env file if it exists
if [ -e .env ]
then
  export $(grep -v '^\s*#' .env | xargs | sed 's/, /,/g')
else
  echo "Could not find $PWD/.env to fetch the latest SSL certs!" 1>&2
  echo "Trying anyway, it should work if the correct environment variables are set elsewhere." 1>&2
fi

./porkcron.py
