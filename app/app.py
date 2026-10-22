from flask import Flask, jsonify, render_template
import subprocess
import time
from app.sensor import CHT832x

app = Flask(__name__)


def read_temperature():
    sensor = CHT832x(bus_number=1)
    try:
        measurement = sensor.read()
        print(
            f"Temperature: "
            f"{measurement['temperature_c']:.2f} °C | "
            f"Humidity: "
            f"{measurement['humidity_rh']:.2f} %RH"
        )
    temperature = measurement['temperature_c']:.2f}
    humidity = measurement['humidity_fh']:.2f}
    time.sleep(1)

    return [temperature, humidity]


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/temperature")
def temperature():
    temp = read_temperature()[0]
    humid = read_temperature()[1]

    return jsonify({
        "temperature": temp,
        "unit": "°C"
    })


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
