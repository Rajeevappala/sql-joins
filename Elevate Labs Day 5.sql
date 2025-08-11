CREATE DATABASE HotelDatabase

USE HotelDatabase


--- CREATE CUSTOMERS TABLE

CREATE TABLE CUSTOMERS (
	CustomerId int primary key identity(1001, 1),
	FirstName Nvarchar(50) Not Null,
	LastName Nvarchar(50) Not Null,
	Email Nvarchar(100) UNIQUE NOT NULL,
	PhoneNumber Nvarchar(20),
	Address Nvarchar(255),
	City Nvarchar(100),
	State Nvarchar(100),
	PostalCode Nvarchar(100),
	Country Nvarchar(100),
	CreatedAt datetime default getDate()

)

--- CREATE ORDERS TABLE

CREATE TABLE ORDERS (
	OrderId int primary key identity(1,1),
	CustomerId Int Not Null,
	OrderDate Nvarchar(50) default getdate(),
	Status Nvarchar(20) Default 'Pending',
	TotalAmount Decimal(10,2) Not Null,
	PaymentMode Nvarchar(20) Not Null,
	ShippingAddress Nvarchar(255),
	foreign key (CustomerId) REFERENCES CUSTOMERS(CustomerId)
		ON DELETE CASCADE
		ON UPDATE CASCADE
		
)

--- INSERTING VALUES INTO CUSTOMERS TABLES 


INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, Address, City, State, PostalCode, Country)
VALUES
('Rajeev', 'Appala', 'rajeev@example.com', '9876543210', '123 Main Street', 'Hyderabad', 'Telangana', '500001', 'India'),
('Saritha', 'Devi', 'saritha@example.com', '9876501234', '45 MG Road', 'Bengaluru', 'Karnataka', '560001', 'India'),
('John', 'Doe', 'john.doe@example.com', '9876000000', '78 Park Avenue', 'Chennai', 'Tamil Nadu', '600001', 'India');


SELECT * FROM CUSTOMERS

--- INSERTING INTO ORDERS TABLES

INSERT INTO ORDERS (CustomerId, OrderDate, Status, TotalAmount, PaymentMode, ShippingAddress)
VALUES
(1001, '2025-08-10', 'Pending', 2500.00, 'UPI', '123 Main Street, Hyderabad'),
(1001, '2025-08-09', 'Shipped', 1500.50, 'Credit Card', '123 Main Street, Hyderabad'),
(1002, '2025-08-08', 'Delivered', 3200.75, 'Cash on Delivery', '45 MG Road, Bengaluru'),
(1003, '2025-08-07', 'Pending', 500.00, 'Net Banking', '78 Park Avenue, Chennai');


select * from ORDERS;

--- Total Orders per Customer

SELECT C.CustomerId, C.FirstName, C.LastName, C.Email, COUNT(OrderId) as TotalOrders
FROM CUSTOMERS AS C INNER JOIN ORDERS AS O ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerId, C.FirstName, C.LastName, C.Email;

--- Total Amount Spent per Customer

SELECT C.CustomerId, C.FirstName, C.LastName, C.Email, SUM(TotalAmount) as TotalAmount
FROM CUSTOMERS AS C INNER JOIN ORDERS AS O ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerId, C.FirstName, C.LastName, C.Email;

--- Average Order Value per Customer

SELECT C.CustomerId, 
       C.FirstName, 
       C.LastName, 
       C.Email,
       ROUND(AVG(O.TotalAmount), 2) AS AverageAmount
FROM Customers AS C
LEFT JOIN Orders AS O
    ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerId, C.FirstName, C.LastName, C.Email;

--- Highest Order Amount per Customer
select 
	C.CustomerId, C.FirstName, C.LastName, C.Email, C.CreatedAt, MAX(TotalAmount) AS HighestOrder
from 
CUSTOMERS AS C 
INNER JOIN ORDERS AS O 
ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerId, C.FirstName, C.LastName, C.Email, C.

--- Customers with More Than 2 Orders

SELECT C.CustomerId,
       C.FirstName,
       C.LastName,
       COUNT(O.OrderID) AS TotalOrders
FROM Customers AS C
LEFT JOIN Orders AS O
    ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerId, C.FirstName, C.LastName
HAVING COUNT(O.OrderID) >= 2;


--- Total Revenue by City 

SELECT C.City,
       SUM(O.TotalAmount) AS TotalRevenue
FROM Orders AS O
RIGHT JOIN Customers AS C
    ON O.CustomerId = C.CustomerId
WHERE C.City IS NOT NULL
GROUP BY C.City;


-- Customers Who Placed Orders in 2025 

SELECT C.CustomerId,
       C.FirstName,
       C.LastName,
       SUM(O.TotalAmount) AS Total2025Spending
FROM Customers AS C
LEFT JOIN Orders AS O
    ON C.CustomerId = O.CustomerId
WHERE YEAR(O.OrderDate) = 2025
GROUP BY C.CustomerId, C.FirstName, C.LastName;

--- Revenue Comparison: Customers vs Non-Customers

SELECT COALESCE(C.FirstName, 'No Customer') AS FirstName,
       COALESCE(C.LastName, '') AS LastName,
       SUM(O.TotalAmount) AS TotalRevenue
FROM Customers AS C
FULL JOIN Orders AS O
    ON C.CustomerId = O.CustomerId
GROUP BY C.FirstName, C.LastName;

--- Highest Order Per City

SELECT C.City,MAX(O.TotalAmount) AS MaxOrderAmount
FROM Customers AS C
LEFT JOIN Orders AS O
    ON C.CustomerId = O.CustomerId
WHERE C.City IS NOT NULL
GROUP BY C.City;
