# BlueOS Extension for CHT832X

This repo integrates the CHT832X temperature and humidity sensor with a Raspberry Pi and BlueOS. 


## Instructions for Direct Raspberry Use

1. Navigate to your extension's source code.

2. Execute the following command to build your extension:

   ```
   cd <path-to-extension>
   docker build .
   docker tag blueos-cht832x:0.1 <user>/blueos-cht832x:0.1
   
   docker login -u <username>
   docker push vrfd01/blueos-cht832x:0.1
    ```
