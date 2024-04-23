from flask import Blueprint, request, jsonify, make_response
import json
from src import db

restock_orders = Blueprint('restock_orders', __name__)

# Get all restock orders from the DB
@restock_orders.route('/restock_orders', methods=['GET'])
def get_all_restock_orders():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM RestockOrders')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    results = cursor.fetchall()
    for result in results:
        json_data.append(dict(zip(row_headers, result)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# Get details for a specific restock order
@restock_orders.route('/restock_orders/<int:restock_order_id>', methods=['GET'])
def get_restock_order(restock_order_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM RestockOrders WHERE RestockOrderID = %s', (restock_order_id,))
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

# Add a new restock order
@restock_orders.route('/restock_orders', methods=['POST'])
def add_restock_order():
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'INSERT INTO RestockOrders (SupplierID, StoreID, ShippedDate, ReceivedDate) VALUES (%s, %s, %s, %s)'
    cursor.execute(query, (data['SupplierID'], data['StoreID'], data['ShippedDate'], data['ReceivedDate']))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Restock order added successfully"}))
    response.status_code = 201
    return response

# Update restock order details
@restock_orders.route('/restock_orders/<int:restock_order_id>', methods=['PUT'])
def update_restock_order(restock_order_id):
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'UPDATE RestockOrders SET SupplierID=%s, StoreID=%s, ShippedDate=%s, ReceivedDate=%s WHERE RestockOrderID=%s'
    cursor.execute(query, (data['SupplierID'], data['StoreID'], data['ShippedDate'], data['ReceivedDate'], restock_order_id))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Restock order updated successfully"}))
    response.status_code = 200
    return response

# Delete a restock order
@restock_orders.route('/restock_orders/<int:restock_order_id>', methods=['DELETE'])
def delete_restock_order(restock_order_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM RestockOrders WHERE RestockOrderID = %s', (restock_order_id,))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Restock order deleted successfully"}))
    response.status_code = 200
    return response
