from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        service="licensing-service",
        status="running",
        version="1.0.0",
    )


@app.get("/healthz")
def health():
    return jsonify(status="healthy")


@app.get("/licenses")
def licenses():
    return jsonify(
        service="licensing-service",
        licenseStatus="valid",
        product="scanning-platform",
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)