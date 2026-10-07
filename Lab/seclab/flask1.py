from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
   return 'Hello World'

@app.route('/task1')
def task1():
   return 'this is task1'
@app.route('/task2')
def task2():
   return 'this is task2'

if __name__ == '__main__':
   app.run(port=80,debug=True,host="0.0.0.0")