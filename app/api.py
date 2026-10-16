import logging
import threading
import time
from datetime import datetime, timezone

from flask import Flask, jsonify

from app.sensor import CHT832x

app = Flask(__name__)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)

sensor = CHT832x(bus_number=1)

lock = threading.Lock()

latest_reading = {
    "temperature_c": None,
    "humidity_rh": None,
    "sensor_ok": False,
    "error": "Waiting for first measurement",
    "updated_at": None,
}


def sensor_worker():
    global latest_reading

    while True:
        try:
            measurement = sensor.read()

            reading = {
                "temperature_c": measurement["temperature_c"],
                "humidity_rh": measurement["humidity_rh"],
                "sensor_ok": True,
                "error": None,
                "updated_at": datetime.now(timezone.utc).isoformat(),
            }

            logging.info(
                "Temperature: %.2f °C | Humidity: %.2f %%RH",
                measurement["temperature_c"],
                measurement["humidity_rh"],
            )

        except Exception as exc:
            logging.exception("CHT832x measurement failed")

            reading = {
                "temperature_c": None,
                "humidity_rh": None,
                "sensor_ok": False,
                "error": str(exc),
                "updated_at": datetime.now(timezone.utc).isoformat(),
            }

        with lock:
            latest_reading = reading

        time.sleep(1)


@app.route("/api/temperature", methods=["GET"])
def get_temperature():
    with lock:
        reading = latest_reading.copy()

    return jsonify(reading)


@app.route("/api/health", methods=["GET"])
def health():
    return jsonify({"service": "cht832x", "status": "running"})


if __name__ == "__main__":
    threading.Thread(
        target=sensor_worker,
        daemon=True,
    ).start()

    logging.info("Starting CHT832x API on port 8082")

    app.run(
        host="0.0.0.0",
        port=8082,
        debug=False,
        use_reloader=False,
    )
