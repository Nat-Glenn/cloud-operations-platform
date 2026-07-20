from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        service="scanning-service",
        status="running",
        version="1.0.0",
    )


@app.get("/healthz")
def health():
    return jsonify(status="healthy")


@app.get("/scan")
def scan():
    return jsonify(
        service="scanning-service",
        result="scan completed",
        findings=0,
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)