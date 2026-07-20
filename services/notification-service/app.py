from flask import Flask, jsonify, request

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        service="notification-service",
        status="running",
        version="1.0.0",
    )


@app.get("/healthz")
def health():
    return jsonify(status="healthy")


@app.post("/notifications")
def notify():
    payload = request.get_json(silent=True) or {}

    return jsonify(
        service="notification-service",
        status="accepted",
        message=payload.get("message", "notification queued"),
    ), 202


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)