#!/bin/sh

set -e

echo "Starting CHT832x driver"

cd /CHT832X/app
/opt/venv/bin/python -u -m /CHT832X/app/app &

echo "Starting Nginx..."
exec nginx -g "daemon off;"
