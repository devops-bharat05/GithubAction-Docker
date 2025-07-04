from flask import Flask
import socket
import os

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    color = os.environ.get('COLOR', 'white')  # Change for each app

    html = f"""
    <html>
        <body style="background-color:{color}; text-align:center; font-family:sans-serif;">
            <h1>Welcome to {color.upper()} Service</h1>
            <p>Served from Pod: <strong>{hostname}</strong></p>
            <p>Pod IP: <strong>{ip_address}</strong></p>
        </body>
    </html>
    """
    return html

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
