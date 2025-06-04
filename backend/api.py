from flask import Flask, jsonify, render_template, request
from flask_cors import CORS
from app import *

app = Flask(__name__)
CORS(app)

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    if not data:
        return jsonify({"error": "Invalid or missing JSON in request"}), 400
    name = data.get('name')
    password = data.get('password')
    
    if not name or not password:
        return jsonify({"error": "Name and password are required"}), 400

    status = logingin(name, data.get('market_name'), password)

    if status == 200:
        return jsonify({"message": "Login successful"}), 200
    elif status == 401:
        return jsonify({"error": "Invalid credentials"}), 401
    else:
        return jsonify({"error": "Employee not found"}), 404

@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    if not data:
        return jsonify({"error": "Invalid or missing JSON in request"}), 400
    name = data.get('name')
    password = data.get('password')
    
    if not name or not password:
        return jsonify({"error": "Name and password are required"}), 400

    status = signingup(name, data.get('market_name'), password)

    if status == 201:
        return jsonify({"message": "Signup successful"}), 201
    elif status == 202:
        return jsonify({"error": "Employee already exists"}), 202
    else:
        return jsonify({"error": "An error occurred during signup"}), 500

if __name__ == '__main__':
    app.run(debug=True)



