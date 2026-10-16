FROM alpine:3.18.3

# Install Nginx and Python
RUN apk add --no-cache \
    nginx \
    python3 \
    py3-pip \
    i2c-tools \
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir Flask smbus2

# Install Nginx configuration
COPY files/nginx.conf /etc/nginx/nginx.conf

# Install the Cockpit registration file and web interface
RUN mkdir -p /site
COPY files/register_service /site/register_service
COPY site/ /site/

# Install the Python application and startup script
RUN mkdir -p /app
COPY app.py /app/app.py
COPY files/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Tell BlueOS that the extension uses HTTP port 80
# and needs access to the Raspberry Pi I2C device.
LABEL permissions='{\
  "ExposedPorts": {\
    "80/tcp": {}\
  },\
  "HostConfig": {\
    "PortBindings": {\
      "80/tcp": [\
        {\
          "HostPort": ""\
        }\
      ]\
    },\
    "Devices": [\
      {\
        "PathOnHost": "/dev/i2c-1",\
        "PathInContainer": "/dev/i2c-1",\
        "CgroupPermissions": "rwm"\
      }\
    ]\
  }\
}'

LABEL authors='[{"name":"CHT832x Extension"}]'
LABEL readme="https://github.com/stormavenger21/CHT832X/blob/main/README.md"

ENTRYPOINT ["/entrypoint.sh"]
