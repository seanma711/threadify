from flask import Blueprint, request, jsonify, make_response
import json
from src import db

suppliers = Blueprint('suppliers', __name__)

# Get all suppliers from the DB
@suppliers.route('/suppliers', methods=['GET'])
def get_all_suppliers():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Suppliers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    results = cursor.fetchall()
    for result in results:
        json_data.append(dict(zip(row_headers, result)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# Get details for a specific supplier
@suppliers.route('/suppliers/<int:supplier_id>', methods=['GET'])
def get_supplier(supplier_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Suppliers WHERE SupplierID = %s', (supplier_id,))
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

# Add a new supplier
@suppliers.route('/suppliers', methods=['POST'])
def add_supplier():
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'INSERT INTO Suppliers (Name, Address, Email, PhoneNumber) VALUES (%s, %s, %s, %s)'
    cursor.execute(query, (data['Name'], data['Address'], data['Email'], data['PhoneNumber']))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Supplier added successfully"}))
    response.status_code = 201
    return response

# Update supplier details
@suppliers.route('/suppliers/<int:supplier_id>', methods=['PUT'])
def update_supplier(supplier_id):
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'UPDATE Suppliers SET Name=%s, Address=%s, Email=%s, PhoneNumber=%s WHERE SupplierID=%s'
    cursor.execute(query, (data['Name'], data['Address'], data['Email'], data['PhoneNumber'], supplier_id))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Supplier updated successfully"}))
    response.status_code = 200
    return response

# Delete a supplier
@suppliers.route('/suppliers/<int:supplier_id>', methods=['DELETE'])
def delete_supplier(supplier_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM Suppliers WHERE SupplierID = %s', (supplier_id,))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Supplier deleted successfully"}))
    response.status_code = 200
    return response
