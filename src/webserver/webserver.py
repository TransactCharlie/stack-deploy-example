__author__ = 'charlie'

from flask import Flask
from environment import get_hostname

app = Flask(__name__)

PAYLOAD = """
<HTML>
<BODY>
<h1>Hello!</h1>
<p>I am Host: <b>{host}</b></p>
</BODY>
</HTML>
"""


@app.route("/")
def hello():
    hn = get_hostname()
    return PAYLOAD.format(host=hn)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
