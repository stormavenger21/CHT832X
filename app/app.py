from flask import Flask, jsonify, render_template
import subprocess
import time
from sensor import CHT832x

app = Flask(__name__)


def read_temperature_rh():
    try:
        sensor = CHT832x(bus_number=1)
    except Exception as error:
        print(f"Init error: {error}")
    try:
        measurement = sensor.read()
        print(
            f"Temperature: "
            f"{measurement['temperature_c']:.2f} °C | "
            f"Humidity: "
            f"{measurement['humidity_rh']:.2f} %RH"
        )
        temperature = measurement['temperature_c']
        humidity = measurement['humidity_rh']
    except Exception as error:
        print(f"Sensor error: {error}")
    time.sleep(1)

    return [temperature, humidity]


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/temperature")
def temperature():
    temp = read_temperature_rh()[0]
    humid = read_temperature_rh()[1]

    return jsonify({
        "temperature": temp,
        "unit": "°C",
        "humidity": humid,
        "unit": "%"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
