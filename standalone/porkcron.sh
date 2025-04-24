#!/usr/bin/env sh

# Move to /etc/porkcron
cd /etc/porkcron

# Read the .env file if it exists
if [ -e .env ]
then
  while IFS== read -r key value; do
    case $key in
      ''|\#*) continue ;;
    esac
    case $value in
      \ \#*|\#*) continue ;;
    esac
    printf -v "$key" %s "$value"
    export "$key"
  done <.env
else
  echo "Could not find $PWD/.env to fetch the latest SSL certs!" 1>&2
  echo "Trying anyway, it should work if the correct environment variables are set elsewhere." 1>&2
fi

./porkcron.py
