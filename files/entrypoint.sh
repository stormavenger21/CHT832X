#!/bin/sh

set -e

echo "Starting CHT832x driver"

cd /app
exec python main.py

echo "Starting Nginx..."
exec nginx -g "daemon off;"
