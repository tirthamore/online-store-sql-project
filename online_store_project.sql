
-- =========================================
-- ONLINE STORE SQL PROJECT
-- Database: MySQL
-- =========================================

CREATE DATABASE IF NOT EXISTS ecommerce_store;
USE ecommerce_store;

-- Disable foreign key checks while resetting
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================
-- STEP 1: CREATE CUSTOMERS TABLE
-- =========================================

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(50)
);

-- =========================================
-- STEP 2: CREATE PRODUCTS TABLE
-- =========================================

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL
);

-- =========================================
-- STEP 3: CREATE ORDERS TABLE
-- =========================================

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

-- =========================================
-- STEP 4: CREATE ORDERDETAILS TABLE
-- =========================================

CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

-- =========================================
-- STEP 5: INSERT CUSTOMERS
-- =========================================

INSERT INTO Customers
(customer_id, customer_name, email, city)
VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com', 'Mumbai'),
(2, 'Priya Patel', 'priya@gmail.com', 'Pune'),
(3, 'Amit Verma', 'amit@gmail.com', 'Delhi'),
(4, 'Sneha Singh', 'sneha@gmail.com', 'Bengaluru'),
(5, 'Arjun Mehta', 'arjun@gmail.com', 'Mumbai');

-- =========================================
-- STEP 6: INSERT PRODUCTS
-- =========================================

INSERT INTO Products
(product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Mouse', 'Accessories', 500.00),
(103, 'Keyboard', 'Accessories', 1200.00),
(104, 'Headphones', 'Electronics', 2000.00),
(105, 'Office Chair', 'Furniture', 7500.00);

-- =========================================
-- STEP 7: INSERT ORDERS
-- =========================================

INSERT INTO Orders
(order_id, customer_id, order_date, total_amount, order_status)
VALUES
(1001, 1, '2026-09-01', 55000.00, 'Delivered'),
(1002, 2, '2026-09-02', 1700.00, 'Delivered'),
(1003, 3, '2026-09-03', 2000.00, 'Shipped'),
(1004, 1, '2026-09-05', 7500.00, 'Pending'),
(1005, 4, '2026-09-06', 1200.00, 'Delivered'),
(1006, 5, '2026-09-08', 55000.00, 'Shipped'),
(1007, 2, '2026-09-10', 500.00, 'Pending'),
(1008, 3, '2026-09-12', 7500.00, 'Delivered');

-- =========================================
-- STEP 8: INSERT ORDER DETAILS
-- =========================================

INSERT INTO OrderDetails
(order_detail_id, order_id, product_id, quantity, unit_price)
VALUES
(1, 1001, 101, 1, 55000.00),
(2, 1002, 103, 1, 1200.00),
(3, 1002, 102, 1, 500.00),
(4, 1003, 104, 1, 2000.00),
(5, 1004, 105, 1, 7500.00),
(6, 1005, 103, 1, 1200.00),
(7, 1006, 101, 1, 55000.00),
(8, 1007, 102, 1, 500.00),
(9, 1008, 105, 1, 7500.00);

-- =========================================
-- STEP 9: VERIFY ALL TABLES
-- =========================================

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;

-- =========================================
-- STEP 10: BASIC ANALYSIS QUERIES
-- =========================================

-- 1. Display all products
SELECT * FROM Products;

-- 2. Find electronics products
SELECT *
FROM Products
WHERE category = 'Electronics';

-- 3. Display orders with customer names
SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    o.order_status
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id;

-- 4. Calculate shipped and delivered order value
SELECT SUM(total_amount) AS total_revenue
FROM Orders
WHERE order_status IN ('Delivered', 'Shipped');

-- 5. Find top-selling products
SELECT
    p.product_name,
    SUM(od.quantity) AS total_sold
FROM Products p
JOIN OrderDetails od
    ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC;

-- 6. Find the highest-priced product
SELECT product_name, price
FROM Products
ORDER BY price DESC
LIMIT 1;

-- 7. Find repeat customers
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1;

-- 8. Calculate total spending per customer
SELECT
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- 9. Find products never ordered
SELECT
    p.product_id,
    p.product_name
FROM Products p
LEFT JOIN OrderDetails od
    ON p.product_id = od.product_id
WHERE od.product_id IS NULL;

-- 10. Calculate revenue by product
SELECT
    p.product_name,
    SUM(od.quantity * od.unit_price) AS product_revenue
FROM Products p
JOIN OrderDetails od
    ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC;