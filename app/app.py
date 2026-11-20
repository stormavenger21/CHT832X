# October 23 2026
# app.py
#
# app.py reads temperature and humidity data from the CHT832x sensor (via sensor.py),
# calculates dew point, formats the measurements as a JSON dictionary,
# then runs a Flask webapp and publishes the data to a development server.

from flask import Flask, jsonify, render_template
import subprocess
import time
import math
from sensor import CHT832x

app = Flask(
    __name__,
    template_folder="webpages"
)


def read_temperature_rh():
    temperature = -273.15
    humidity = 0.0

    try:
        sensor = CHT832x(bus_number=1)
    except Exception as error:
        print(f"Init error: {error}")
        return [temperature, humidity]

    try:
        measurement = sensor.read()
        temperature = measurement['temperature_c']
        humidity = measurement['humidity_rh']

    except Exception as error:
        print(f"Sensor error: {error}")

    time.sleep(1)

    return [temperature, humidity]


def calculate_dew_point(temperature, humidity):
    """
    Calculate dew point using the Magnus formula.

    Temperature: °C
    Humidity: Relative humidity (%)
    Returns: Dew point in °C
    """

    if humidity <= 0 or humidity > 100:
        return None

    gamma = (
        math.log(humidity / 100.0)
        + (17.62 * temperature) / (243.12 + temperature)
    )

    dew_point = (243.12 * gamma) / (17.62 - gamma)

    return round(dew_point, 2)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/temperature")
def temperature():
    temp, humid = read_temperature_rh()

    dew_point = calculate_dew_point(temp, humid)

    return jsonify({
        "temperature": temp,
        "unit (temp)": "°C",

        "humidity": humid,
        "unit (humidity)": "%",

        "dew_point": dew_point,
        "unit (dew_point)": "°C"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
