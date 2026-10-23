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

#Host port is dynamically assigned
#Container port is 80
LABEL permissions='{\
  "ExposedPorts": {\
    "80/tcp": {}\
  },\
  "HostConfig": {\
    "CpuPeriod":100000,\
    "CpuQuota":20000,\
    "Memory":209715200,\
    "PortBindings": {\
      "80/tcp": [\
        {\
          "HostPort": "5000/tcp"\ 
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

LABEL authors='[{"name":"stormavenger21"}]'
LABEL readme="https://github.com/stormavenger21/CHT832X/blob/main/README.md"

ENTRYPOINT ["/entrypoint.sh"]
