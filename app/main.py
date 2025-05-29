from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Jenkins CI build! and CD deploy using helm and testing auto trigger CI and shown demo to bhagyaraj🚀"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
