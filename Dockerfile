FROM alpine:3.18.3

RUN apk add --no-cache \
    nginx \
    python3 \
    py3-pip \
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir Flask smbus2

# Nginx configuration
COPY files/nginx.conf /etc/nginx/nginx.conf

# Web interface and Cockpit registration
RUN mkdir -p /site
COPY files/register_service /site/register_service
COPY site/ /site/

# Python sensor driver and API
RUN mkdir -p /app/app
COPY app/ /app/app/

# Startup script
COPY files/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app

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
