#!/bin/sh

set -e

echo "Starting CHT832x API..."

cd /app
exec python main.py
# /opt/venv/bin/python -u -m app.api &

echo "Starting Nginx..."
exec nginx -g "daemon off;"
