#!/bin/sh

set -e

echo "Starting CHT832x driver"

cd /CHT832X/app
/opt/venv/bin/python -u -m app.app &

echo "Starting Nginx..."
exec nginx -g "daemon off;"
