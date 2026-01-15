from flask import Flask, request

from functions import get_an


app = Flask(__name__)


@app.route('/')
def index():
    return "<h1 style='color: blue;'> Gomelskyi Semen </h1>"


@app.route('/fibonacci')
def an_endpoint():

    try:

        n = request.args.get('n', None)

        if n is None:
            return "<p style='color: red;'> 'n' is required </p>"
        else:
            n = int(n)

        number = get_an(n)

        return f"<p style='color: green;'> The {n}-th Fibonacci number is {number} </p>"

    except Exception as exception:
        return f"<p style='color: red;'> {type(exception).name}: {exception} </p>"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9090, debug=True)
