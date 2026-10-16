#!/bin/sh

set -e

echo "Starting CHT832x API..."

cd /app
/opt/venv/bin/python -u -m app.api &

echo "Starting Nginx..."
exec nginx -g "daemon off;"
