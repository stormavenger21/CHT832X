FROM alpine:3.18.3

#RUN apt update && apt install -y python3 python3-venv python3-pip

RUN apk add --no-cache \
    nginx \
    python3 \
    py3-pip \
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir Flask smbus2

# Nginx configuration
COPY files/nginx.conf /etc/nginx/nginx.conf

# Web interface and Cockpit registration
RUN mkdir -p /CHT832X
RUN mkdir -p /CHT832X/files
COPY files/register_service /CHT832X/files/register_service


# Python sensor driver and API
RUN mkdir -p /CHT832X/app
COPY app/ /CHT832X/app

# Startup script
COPY files/entrypoint.sh /CHT832X/files/entrypoint.sh
RUN chmod +x /CHT832X/files/entrypoint.sh

WORKDIR /CHT832X/app

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
    "Binds":[\
      "/dev:/dev"\
    ]\
  }\
}'

LABEL authors='[{"name":"stormavenger21"}]'
LABEL readme="https://github.com/stormavenger21/CHT832X/blob/main/README.md"

ENTRYPOINT ["/CHT832X/files/entrypoint.sh"]
