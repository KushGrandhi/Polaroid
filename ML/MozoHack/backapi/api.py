from flask import Flask, jsonify, request, render_template 
import sqlite3
import json
import random


app = Flask(__name__) 

@app.route('/test',methods=['POST'])
def test():
    if request.method == 'POST':
        user = request.get_json(force=True)
        print(user)
        print('success')
    return 'success'
if __name__ == '__main__': 
    app.run(debug = True) 