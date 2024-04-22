DROP DATABASE threadify_db;
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
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)  ON DELETE CASCADE
);

CREATE TABLE RestockOrderItems (
    RestockOrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    FOREIGN KEY (RestockOrderID) REFERENCES RestockOrders(RestockOrderID) ON DELETE CASCADE,
    PRIMARY KEY (RestockOrderID, ProductID)
);

CREATE TABLE StoreItems (
    StoreID INT,
    ProductID INT,
    CurrentStock INT,
    MinStock INT,
    InSeason BOOLEAN,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID) ON DELETE CASCADE
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
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID) ON DELETE CASCADE
);

CREATE TABLE PurchaseItems (
    PurchaseID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID) ON DELETE CASCADE,
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