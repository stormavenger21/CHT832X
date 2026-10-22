from flask import Flask, jsonify, render_template
import subprocess

app = Flask(__name__)


def read_temperature():


    # Example only: replace with your actual sensor reading.
    temperature = 23.5

    return temperature


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/temperature")
def temperature():
    temp = read_temperature()

    return jsonify({
        "temperature": temp,
        "unit": "°C"
    })


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
