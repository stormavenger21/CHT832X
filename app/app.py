# October 23 2026
# app.py 
#
# app.py runs reads temperature and humidity date from the CHT832x sensor (via sensor.py), 
# formats as JSON dict, then runs a Flask webapp and publishes the data to a development server

from flask import Flask, jsonify, render_template
import subprocess
import time
from sensor import CHT832x

app = Flask(__name__)


def read_temperature_rh():
    temperature = -273.15
    humidity = 0.0
    try:
        sensor = CHT832x(bus_number=1)
    except Exception as error:
        print(f"Init error: {error}")
    try:
        measurement = sensor.read()
        temperature = measurement['temperature_c']
        humidity = measurement['humidity_rh']
    except Exception as error:
        print(f"Sensor error: {error}")
    time.sleep(1)

    return [temperature, humidity]


@app.route("/")
def index():
    return render_template("/site/index.html")


@app.route("/temperature")
def temperature():
    temp = read_temperature_rh()[0]
    humid = read_temperature_rh()[1]

    return jsonify({
        "temperature": temp,
        "unit (temp)": "°C",
        "humidity": humid,
        "unit (humidity)": "%"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
