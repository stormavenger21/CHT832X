# BlueOS Extension for CHT832X
This repo integrates the CHT832X temperature and humidity sensor with a Raspberry Pi and BlueOS. Humidity, temperature and dew point are displayed on a website.


## Installation Instructions
_to do_

### Expose the I2C Bus to the Docker Container
__Problem:__ the docker container was not able to communicate with the i2c bus on the raspberry pi. After entering the docker command shell for the CHT832x container, ```/dev/i2c-1``` was not visible, but should be. 

__Resolution:__ To expose the i2c-1 bus only, go to  ```blueOS > extensions > installed > CHT832x Temperature Sensor > edit``` and add:
```
{
  "ExposedPorts": {
    "5000/tcp": {}
  },
  "HostConfig": {
    "CpuPeriod": 100000,
    "CpuQuota": 20000,
    "Memory": 209715200,
    "PortBindings": {
      "5000/tcp": [
        {
          "HostPort": "5000/tcp"
        }
      ]
    },
    "Devices": [
      {
        "PathOnHost": "/dev/i2c-1",
        "PathInContainer": "/dev/i2c-1",
        "CgroupPermissions": "rw"
      }
    ]
  }
}
```



## Testing (without docker)

- Navigate to your extension's source code.

- Execute the following command to build the extension:

```
cd <path-to-extension>
docker build .
docker tag blueos-cht832x:0.1 <user>/blueos-cht832x:0.1

docker login -u <username>
docker push vrfd01/blueos-cht832x:0.1
 ```

- Execute a git pull into the raspberry pi
```
git pull
```

- activate python virtual environment
```
source myenv/bin/activate
```

- run the app.py and open a webpage to see the data
```
cd app && python3 app.py
curl <ip:5000>
```
