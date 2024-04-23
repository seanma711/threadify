from flask import Blueprint, request, jsonify, make_response
import json
from src import db

customers = Blueprint('customers', __name__)

# This Gets all customers from the DB
@customers.route('/customers', methods=['GET'])
def get_all_customers():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Customers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    results = cursor.fetchall()
    for result in results:
        json_data.append(dict(zip(row_headers, result)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

# Get details for a specific customer
@customers.route('/customers/<int:customer_id>', methods=['GET'])
def get_customer(customer_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Customers WHERE CustomerID = %s', (customer_id,))
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

# Adds a new customer
@customers.route('/customers', methods=['POST'])
def add_customer():
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'INSERT INTO Customers (Name, PhoneNumber, Email, RewardsMember) VALUES (%s, %s, %s, %s)'
    cursor.execute(query, (data['Name'], data['PhoneNumber'], data['Email'], data['RewardsMember']))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Customer added successfully"}))
    response.status_code = 201
    return response

# Update customer details
@customers.route('/customers/<int:customer_id>', methods=['PUT'])
def update_customer(customer_id):
    data = request.get_json()
    cursor = db.get_db().cursor()
    query = 'UPDATE Customers SET Name=%s, PhoneNumber=%s, Email=%s, RewardsMember=%s WHERE CustomerID=%s'
    cursor.execute(query, (data['Name'], data['PhoneNumber'], data['Email'], data['RewardsMember'], customer_id))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Customer updated successfully"}))
    response.status_code = 200
    return response

# Delete a customer
@customers.route('/customers/<int:customer_id>', methods=['DELETE'])
def delete_customer(customer_id):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM Customers WHERE CustomerID = %s', (customer_id,))
    db.get_db().commit()
    response = make_response(jsonify({"message": "Customer deleted successfully"}))
    response.status_code = 200
    return response
