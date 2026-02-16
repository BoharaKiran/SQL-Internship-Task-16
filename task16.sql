use intern_training_db;

#Create tables representing a sales system
-- Customers table
CREATE TABLE Customers11 (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15),
    join_date DATE
);

-- Products table
CREATE TABLE Products11 (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

-- Orders table
CREATE TABLE Orders11 (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers11(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products11(product_id)
);

show tables;
#Insert realistic transactional data
INSERT INTO Customers11(first_name, last_name, email, phone, join_date)values
('Hina','Sarma','hina@gmail.com','1234567890','2023-01-15'),
('Mina','Varma','mina@gmail.com','1234566890','2023-02-11'),
('Janvi','Kumari','janvi@gmail.com','1234567890','2023-04-25'),
('Meet','kapoor','meet@gmail.com','1234567890','2023-06-20');

INSERT INTO Products11 (product_name, category, price, stock_quantity)
VALUES
('Laptop', 'Electronics', 1200.00, 50),
('Headphones', 'Electronics', 150.00, 200),
('Coffee Maker', 'Home Appliances', 80.00, 100),
('Desk Chair', 'Furniture', 250.00, 75);

INSERT INTO Orders11 (customer_id, product_id, quantity, order_date)
VALUES
(1, 1, 1, '2023-06-01'),
(1, 2, 2, '2023-06-15'),
(2, 2, 1, '2023-06-20'),
(3, 3, 1, '2023-07-05'),
(3, 4, 1, '2023-07-10'),
(4, 1, 2, '2023-08-01'),
(4, 2, 1, '2023-08-05');

#find top-selling products.
SELECT p.product_name,
       SUM(o.quantity) AS total_sold
FROM Orders11 o
JOIN Products11 p ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC;

#monthly revenue trends
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(o.quantity * p.price) AS monthly_revenue
FROM Orders11 o
JOIN Products11 p ON o.product_id = p.product_id
GROUP BY month
ORDER BY month;

#inactive customers
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers11 c
LEFT JOIN Orders11 o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
    OR MAX(o.order_date) IS NULL;

#Detect high-value customers using aggregates
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(o.quantity * p.price) AS total_spent
FROM Customers11 c
JOIN Orders11 o ON c.customer_id = o.customer_id
JOIN Products11 p ON o.product_id = p.product_id
GROUP BY c.customer_id
HAVING total_spent > 1000
ORDER BY total_spent DESC;

#Optimize complex analytical queries
CREATE INDEX idx_order_date ON Orders11(order_date);
CREATE INDEX idx_product_id ON Orders11(product_id);

#Document insights as if reporting to management
/*1. Top-Selling Products:The most sold products are giving the highest revenue. 
These products are popular among customers.
 Management should keep more stock of these items to avoid shortages.
 
 2.Monthly Revenue Trend:Sales revenue changes every month. Some months have higher sales and some have
 lower sales.

3.Inactive Customers:Some customers have not placed orders for a long time.

4.High-Value Customers:Some customers spend more money than others.
 These customers are very important for business.
 
 5.Overall Business Performance:Sales data helps understand customer behavior, 
 product demand, and revenue growth.
 
 6.Recommendation:
Increase stock for popular products
Give offers in low-sales months
Contact inactive customers
Reward high-value customers
*/