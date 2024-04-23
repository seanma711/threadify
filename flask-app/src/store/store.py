
from flask import Blueprint, request, jsonify, make_response
import json
from src import db

stores = Blueprint('stores', __name__)

# Get all stores from the DB
@stores.route('/stores', methods=['GET'])
def get_stores():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Stores')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    results = cursor.fetchall()
    for result in results:
        json_data.append(dict(zip(row_headers, result)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# Get details for a specific store
@stores.route('/stores/<int:store_id>', methods=['GET'])
def get_store(store_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Stores WHERE StoreID = %s', (store_id,))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    result = cursor.fetchone()
    if result:
        json_data = dict(zip(row_headers, result))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# Add a new store
@stores.route('/stores', methods=['POST'])
def add_store():
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'INSERT INTO Stores (Name, Address, Email, PhoneNumber, Manager) VALUES (%s, %s, %s, %s, %s)'
    cursor.execute(query, (data['Name'], data['Address'], data['Email'], data['PhoneNumber'], data['Manager']))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Store added successfully"}))
    response.status_code = 201
    return response

# Update store details
@stores.route('/stores/<int:store_id>', methods=['PUT'])
def update_store(store_id):
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'UPDATE Stores SET Name=%s, Address=%s, Email=%s, PhoneNumber=%s, Manager=%s WHERE StoreID=%s'
    cursor.execute(query, (data['Name'], data['Address'], data['Email'], data['PhoneNumber'], data['Manager'], store_id))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Store updated successfully"}))
    response.status_code = 200
    return response

# Delete a store
@stores.route('/stores/<int:store_id>', methods=['DELETE'])
def delete_store(store_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM Stores WHERE StoreID = %s', (store_id,))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Store deleted successfully"}))
    response.status_code = 200
    return response
