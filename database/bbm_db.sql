SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- Create Table for Manufacturers 
DROP TABLE IF EXISTS `Manufacturers`;
CREATE TABLE Manufacturers (
    manufacturer_id int(11) AUTO_INCREMENT,
    manufacturer_name varchar(255) NOT NULL,
    PRIMARY KEY (manufacturer_id)
);
-- Create Table for Products, manufacturer_id as FK and delete cascade
DROP TABLE IF EXISTS `Products`;
CREATE TABLE Products (
    product_id int(11) AUTO_INCREMENT,
    product_name varchar(255) NOT NULL,
    product_price decimal(15,2) NOT NULL,
    manufacturer_id int(11),
    FOREIGN KEY (manufacturer_id) REFERENCES Manufacturers(manufacturer_id) ON DELETE CASCADE,
    PRIMARY KEY (product_id)
);
-- Create Table for Customers
DROP TABLE IF EXISTS `Customers`;
CREATE TABLE Customers (
    customer_id int(11) AUTO_INCREMENT,
    customer_name varchar(255) NOT NULL,
    date_created DATE NOT NULL,
    customer_email varchar(255) NOT NULL,
    customer_phone varchar(255),
    PRIMARY KEY (customer_id)
);
-- Create Table for Invoices, customer_id as FK
DROP TABLE IF EXISTS `Invoices`;
CREATE TABLE Invoices (
    invoice_id int(11) AUTO_INCREMENT,
    customer_id int(11),
    transaction_date DATE,
    total_price decimal(15,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    PRIMARY KEY (invoice_id)
);
-- Create Table for Sales, product_id as FK and delete set NULL for CASCADE
DROP TABLE IF EXISTS `Sales`;
CREATE TABLE Sales (
    invoice_id int(11),
    product_id int(11),
    quantity_sold int(11) NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES Invoices(invoice_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE SET NULL
);

-- Queries

-- Insert for Manufacturers with only the manufacturer_name
INSERT INTO Manufacturers(
    manufacturer_name
)
VALUES
(
    "Keyboard Inc."
),
(
    "Mouse Inc."
),
(
    "Headphone Inc."
);

-- Insert for Products with product_name, product_price, and manufacturer_id from Manufacturers
INSERT INTO Products(
    product_name,
    product_price,
    manufacturer_id
)
VALUES
(
    "Keyboard",
    200.00,
    (SELECT manufacturer_id FROM Manufacturers WHERE manufacturer_name = "Keyboard Inc.")
),
( 
    "Mouse",
    95.00,
    (SELECT manufacturer_id FROM Manufacturers WHERE manufacturer_name = "Mouse Inc.")
),
(
    "Headphone",
    150.00,
    (SELECT manufacturer_id FROM Manufacturers WHERE manufacturer_name = "Headphone Inc.")
);

-- Insert for Customers with customer_name, date_create, customer_email, and customer_phone
INSERT INTO Customers(
    customer_name,
    date_created,
    customer_email,
    customer_phone
)
VALUES
(
    "Sarah",
    "2023-01-01",
    "sarah@email.com",
    "111-111-1111"
),
(
    "Michael",
    "2023-01-15",
    "mike@email.com",
    "222-222-2222"
),
(
    "Lewis",
    "2023-02-01",
    "lewi@email.com",
    "333-333-3333"
);

-- Insert for Invoices with customer_id from Customers and total_price
INSERT INTO Invoices(
    customer_id,
    transaction_date,
    total_price
)
VALUES
(
    (SELECT customer_id FROM Customers WHERE customer_name = "Sarah"),
    "2023-01-01",
    350.00
),
(
    (SELECT customer_id FROM Customers WHERE customer_name = "Michael"),
    "2023-01-15",
    295.00
),
(
    (Select customer_id FROM Customers WHERE customer_name = "Lewis"),
    "2023-02-01",
    445.00
);

-- Insert for Sales with invoice_id from Invoices, product_id from Products, and quantity_sold
INSERT INTO Sales (
    invoice_id,
    product_id,
    quantity_sold
)
VALUES
(
    (SELECT invoice_id FROM Invoices WHERE customer_id = (SELECT customer_id FROM Customers WHERE customer_name = "Sarah")),
    (SELECT product_id FROM Products WHERE product_name = "Keyboard"),
    1
),
(
    (SELECT invoice_id FROM Invoices WHERE customer_id = (SELECT customer_id FROM Customers WHERE customer_name = "Sarah")),
    (Select product_id FROM Products WHERE product_name = "Headphone"),
    1
),
(
    (SELECT invoice_id FROM Invoices WHERE customer_id = (SELECT customer_id FROM Customers WHERE customer_name = "Michael")),
    (SELECT product_id FROM Products WHERE product_name = "Keyboard"),
    1
),
(
    (SELECT invoice_id FROM Invoices WHERE customer_id = (SELECT customer_id FROM Customers WHERE customer_name = "Michael")),
    (SELECT product_id FROM Products WHERE product_name = "Mouse"),
    1
),
(
    (SELECT invoice_id FROM Invoices WHERE customer_id = (SELECT customer_id FROM Customers WHERE customer_name = "Lewis")),
    (SELECT product_id FROM Products WHERE product_name = "Keyboard"),
    1
),
(
    (SELECT invoice_id FROM Invoices WHERE customer_id = (SELECT customer_id FROM Customers WHERE customer_name = "Lewis")),
    (SELECT product_id FROM Products WHERE product_name = "Mouse"),
    1
),
(
    (SELECT invoice_id FROM Invoices WHERE invoice_id = (SELECT customer_id FROM Customers WHERE customer_name = "Lewis")),
    (SELECT product_id FROM Products WHERE product_name = "Headphone"),
    1
);

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;