from flask import Blueprint, request, jsonify, make_response
import json
from src import db

purchases = Blueprint('purchases', __name__)

# Get all purchases from the DB
@purchases.route('/', methods=['GET'])
def get_all_purchases():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Purchases')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    results = cursor.fetchall()
    for result in results:
        json_data.append(dict(zip(row_headers, result)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# Get details for a specific purchase
@purchases.route('/<int:purchase_id>', methods=['GET'])
def get_purchase(purchase_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Purchases WHERE PurchaseID = %s', (purchase_id,))
    row_headers = [x[0] for x in cursor.description]
    result = cursor.fetchone()
    if result:
        json_data = dict(zip(row_headers, result))
    else:
        json_data = {}
    response = make_response(jsonify(json_data))
    response.status_code = 200 if result else 404
    response.mimetype = 'application/json'
    return response

# Add a new purchase
@purchases.route('/', methods=['POST'])
def add_purchase():
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'INSERT INTO Purchases (CustomerID, StoreID, BuyDate) VALUES (%s, %s, %s)'
    cursor.execute(query, (data['CustomerID'], data['StoreID'], data['BuyDate']))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Purchase added successfully"}))
    response.status_code = 201
    return response

# Update purchase details
@purchases.route('/<int:purchase_id>', methods=['PUT'])
def update_purchase(purchase_id):
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'UPDATE Purchases SET CustomerID=%s, StoreID=%s, BuyDate=%s WHERE PurchaseID=%s'
    cursor.execute(query, (data['CustomerID'], data['StoreID'], data['BuyDate'], purchase_id))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Purchase updated successfully"}))
    response.status_code = 200
    return response

# Delete a purchase
@purchases.route('/<int:purchase_id>', methods=['DELETE'])
def delete_purchase(purchase_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM Purchases WHERE PurchaseID = %s', (purchase_id,))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Purchase deleted successfully"}))
    response.status_code = 200
    return response

# Get all items for a specific purchase
@purchases.route('/<int:purchase_id>/items', methods=['GET'])
def get_purchase_items(purchase_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM PurchaseItems WHERE PurchaseID = %s', (purchase_id,))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    results = cursor.fetchall()
    for result in results:
        json_data.append(dict(zip(row_headers, result)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response
