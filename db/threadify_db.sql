DROP DATABASE threadify_db;
CREATE DATABASE threadify_db;
USE threadify_db;

CREATE TABLE ProductTypes (
    TypeID INT PRIMARY KEY,
    Name VARCHAR(255)
);

CREATE TABLE Seasons (
    SeasonID INT PRIMARY KEY,
    Name VARCHAR(255)
);

Create TABLE ProductGenders (
    GenderID INT PRIMARY KEY,
    Name VARCHAR(255)
);
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    Email VARCHAR(255),
    PhoneNumber VARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    TypeID INT,
    ImgURL VARCHAR(255),
    Name VARCHAR(255),
    GenderID INT,
    SeasonID INT,
    FOREIGN KEY (TypeID) REFERENCES ProductTypes(TypeID),
    FOREIGN KEY (SeasonID) REFERENCES Seasons(SeasonID),
    FOREIGN KEY (GenderID) REFERENCES ProductGenders(GenderID)
);

CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    Email VARCHAR(255),
    PhoneNumber VARCHAR(255),
    Manager VARCHAR(255)
);

CREATE TABLE RestockOrders (
    RestockOrderID INT PRIMARY KEY,
    SupplierID INT,
    StoreID INT,
    ShippedDate DATE,
    ReceivedDate DATE,
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
    PhoneNumber VARCHAR(255),
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