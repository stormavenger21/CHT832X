# BlueOS Extension for CHT832X

This repo integrates the CHT832X temperature and humidity sensor with a Raspberry Pi and BlueOS. 


## Instructions for Direct Raspberry Use

- Navigate to your extension's source code.

- Execute the following command to build your extension:

   ```
   cd <path-to-extension>
   docker build .
   docker tag blueos-cht832x:0.1 <user>/blueos-cht832x:0.1
   
   docker login -u <username>
   docker push vrfd01/blueos-cht832x:0.1
    ```


## Testing 

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
