from flask import Flask
from flask import request

app = Flask(
    __name__,
    static_folder="public",
    static_url_path="/")

@app.route("/")
def hello():
    print("method:", request.method)
    print("scheme:", request.scheme)
    print("host:", request.host)
    print("path:", request.path)
    print("url:", request.url)
    print("user agent:", request.user_agent)
    print("accept-languages:", request.accept_languages)
    print("refer:", request.referrer)

    lang = request.args.get("lang")
    if lang=="en":
        return f"Hello, World! ({lang})"
    else:
        return "Yo"

@app.route("/data")
def data():
    return "My data"

@app.route("/data/<username>")
def user(username):
    return f"Hello, {username}"

app.run(port=3000)