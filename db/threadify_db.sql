CREATE DATABASE threadify_db;
USE threadify_db;

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    Email VARCHAR(255),
    Number VARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Type VARCHAR(255),
    ImgURL VARCHAR(255),
    Name VARCHAR(255),
    Season VARCHAR(255)
);

CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    Number VARCHAR(255),
    Manager VARCHAR(255)
);

CREATE TABLE RestockOrders (
    RestockOrderID INT PRIMARY KEY,
    SupplierID INT,
    StoreID INT,
    ShippingDate DATE,
    ShippedDate DATE,
    ShipmentConfirmation BOOLEAN,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

CREATE TABLE RestockOrderItems (
    RestockOrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (RestockOrderID) REFERENCES RestockOrders(RestockOrderID),
    PRIMARY KEY (RestockOrderID, ProductID)
);

CREATE TABLE StoreItems (
    StoreID INT,
    ProductID INT,
    CurrentStock INT,
    MinStock INT,
    InSeason BOOLEAN,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Number VARCHAR(255),
    Email VARCHAR(255),
    RewardsMember BOOLEAN
);

CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY,
    CustomerID INT,
    StoreID INT,
    BuyDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

CREATE TABLE PurchaseItems (
    PurchaseID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID),
    PRIMARY KEY (PurchaseID, ProductID)
);

INSERT INTO Products (ProductID, Type, ImgURL, Name, Season)
VALUES
(101, 'Shirt', 'http://example.com/shirt.jpg', 'T-Shirt', 'Summer'),
(102, 'Pants', 'http://example.com/pants.jpg', 'Jeans', 'All'),
(103, 'Jacket', 'http://example.com/jacket.jpg', 'Jacket', 'Winter');

INSERT INTO Stores (StoreID, Name, Address, Number, Manager)
VALUES
(201, 'Carson\'s Fits', '123 Main St', '555-1234', 'Ken Carson'),
(202, 'Suburb Style', '456 Side St', '555-5678', 'John Smith'),
(203, 'City Center Clothes', '789 Broad St', '555-9012', 'Alice Johnson');


INSERT INTO Suppliers (SupplierID, Name, Address, Email, Number)
VALUES
(301, 'Elon Fabrics', '100 Fashion Blvd', 'contact@trendmakers.com', '555-0001'),
(302, 'Denim Suppliers', '200 Jean Ave', 'sales@denim.com', '555-0002'),
(303, 'Coat Corner', '300 Winter Ln', 'info@coatcorner.com', '555-0003');

INSERT INTO Customers (CustomerID, Name, Number, Email, RewardsMember)
VALUES
(401, 'Mario Judah', '555-0101', 'mjthegoat@goats.com', true),
(402, 'Chris Lee', '555-0202', 'chris@site.com', false),
(403, 'Pat Kim', '555-0303', 'pat@web.com', true);

INSERT INTO RestockOrders (RestockOrderID, SupplierID, StoreID, ShippingDate, ShippedDate, ShipmentConfirmation)
VALUES
(501, 301, 201, '2023-04-10', '2023-04-12', true),
(502, 302, 202, '2023-04-11', '2023-04-13', false),
(503, 303, 203, '2023-04-12', '2023-04-14', true);

INSERT INTO RestockOrderItems (RestockOrderID, ProductID, Quantity)
VALUES
(501, 101, 100),
(502, 102, 150),
(503, 103, 200);

INSERT INTO StoreItems (StoreID, ProductID, CurrentStock, MinStock, InSeason)
VALUES
(201, 101, 50, 20, true),
(202, 102, 30, 15, true),
(203, 103, 25, 10, false);

INSERT INTO Purchases (PurchaseID, CustomerID, StoreID, BuyDate)
VALUES
(601, 401, 201, '2023-04-15'),
(602, 402, 202, '2023-04-16'),
(603, 403, 203, '2023-04-17');

INSERT INTO PurchaseItems (PurchaseID, ProductID, Quantity)
VALUES
(601, 101, 2),
(602, 102, 1),
(603, 103, 1);

SELECT * FROM Customers WHERE Name = 'Mario Judah';

DELETE FROM Suppliers WHERE Name = 'Elon Fabrics';

INSERT INTO Suppliers (SupplierID, Name, Address, Email, Number)
VALUES (304, 'Thread Masters', '400 Thread Ct', 'contact@threadmasters.com', '555-0102');


SELECT * FROM Products WHERE Season = 'All';

UPDATE Stores
SET Manager = 'Linda Brown'
WHERE StoreID = 202;

DELETE FROM Purchases
WHERE PurchaseID = 603;

SELECT p.Name, s.Name AS SupplierName, r.ShippingDate
FROM RestockOrders r
JOIN Suppliers s ON r.SupplierID = s.SupplierID
JOIN RestockOrderItems roi ON r.RestockOrderID = roi.RestockOrderID
JOIN Products p ON roi.ProductID = p.ProductID
WHERE r.StoreID = 201;

UPDATE StoreItems
SET CurrentStock = CurrentStock + 10
WHERE StoreID = 201 AND ProductID = 101;

-- Insert the purchase
INSERT INTO Purchases (PurchaseID, CustomerID, StoreID, BuyDate)
VALUES (604, 401, 202, '2023-05-01');

-- Insert the items bought
INSERT INTO PurchaseItems (PurchaseID, ProductID, Quantity)
VALUES
(604, 101, 3),
(604, 102, 2);

-- CRUD Queries
SELECT Name, Email FROM Customers WHERE RewardsMember = TRUE;

UPDATE RestockOrders
SET ShipmentConfirmation = TRUE
WHERE RestockOrderID = 502;

DELETE FROM Suppliers
WHERE SupplierID = 303;