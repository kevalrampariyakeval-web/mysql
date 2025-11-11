CREATE DATABASE IF NOT EXISTS project;
USE project;

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE,
    Address VARCHAR(255)
);

INSERT INTO Customers (Name, Email, Address) VALUES
('Alice', 'alice@email.com', '123 Road A'),
('Bob', 'bob@email.com', '456 Road B'),
('Carol', 'carol@email.com', '789 Road C'),
('Dave', 'dave@email.com', '101 Road D'),
('Eve', 'eve@email.com', '202 Road E');

SELECT * FROM Customers;
UPDATE Customers SET Address = '456 Road B' WHERE CustomerID = 2;
DELETE FROM Customers WHERE CustomerID = 4;
SELECT * FROM Customers WHERE Name LIKE 'Alice';
---------

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(12,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);


INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, DATE_SUB(CURRENT_DATE(), INTERVAL 5 DAY), 2850.00),
(2, DATE_SUB(CURRENT_DATE(), INTERVAL 40 DAY), 450.00),
(1, DATE_SUB(CURRENT_DATE(), INTERVAL 20 DAY), 1999.00),
(3, DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY), 1500.00),
(5, DATE_SUB(CURRENT_DATE(), INTERVAL 10 DAY), 750.00);


SELECT * FROM Orders WHERE CustomerID = 1;
UPDATE Orders SET TotalAmount = 500.00 WHERE OrderID = 2;
DELETE FROM Orders WHERE OrderID = 2;
SELECT * FROM Orders WHERE OrderDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY);

-------

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Stock INT NOT NULL DEFAULT 0 CHECK (Stock >= 0)
);

INSERT INTO Products (ProductName, Price, Stock) VALUES
('Laptop', 70000, 10),
('Mouse', 1200, 50),
('Keyboard', 2500, 40),
('Monitor', 15000, 20),
('Webcam', 2000, 0);

SELECT * FROM Products ORDER BY Price DESC;
UPDATE Products SET Price = ROUND(Price * 1.10, 2) WHERE ProductID = 5;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Products WHERE Stock = 0;
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM Products WHERE Price BETWEEN 500 AND 2000;
SELECT MAX(Price) AS MostExpensive, MIN(Price) AS Cheapest FROM Products;

-------

CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    SubTotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


INSERT INTO OrderDetails (OrderID, ProductID, Quantity, SubTotal) VALUES
(1, 1, 2, 140000.00),  
(1, 2, 1, 1200.00),  
(3, 3, 1, 2500.00),  
(4, 4, 1, 15000.00),  
(5, 2, 2, 2400.00);


SELECT * FROM OrderDetails WHERE OrderID = 1;
SELECT SUM(SubTotal) AS TotalRevenue FROM OrderDetails;
SELECT ProductID, SUM(Quantity) AS TotalQuantitySold
FROM OrderDetails
GROUP BY ProductID
ORDER BY TotalQuantitySold DESC
LIMIT 3;

SELECT COUNT(*) AS TimesProductAppearedInOrders
FROM OrderDetails
WHERE ProductID = 2;
