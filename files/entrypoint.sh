#!/bin/sh

set -e

echo "Starting CHT832x sensor application..."

# Start the Python API in the background.
/opt/venv/bin/python -u /test_sensor.py &

echo "Starting Nginx..."

# Keep Nginx in the foreground so Docker tracks it correctly.
exec nginx -g "daemon off;"
