-- Select all Manufacturers
SELECT * FROM Manufacturers;

-- Select all from Products
SELECT * FROM Products;

-- Select all from Customers
SELECT * FROM Customers;

-- Select all from Sales
SELECT * FROM Sales;

-- Select all from Invoices
SELECT * FROM Invoices;

-- Insert into Manufacturers Table
INSERT INTO Manufacturers (manufacturer_name)
Values (:manufacturer_name);

-- Insert into Products Talbe
INSERT INTO Products 
(
    product_name, 
    product_price
)
VALUES 
(
    :product_name, 
    :product_price
);

-- Insert into Customers Table
INSERT INTO Customers 
(
    customer_name,
    date_created, 
    customer_email, 
    customer_phone
)
VALUES 
(
    :customer_name, 
    :date_created, 
    :customer_email, 
    :customer_phone
);

-- Insert into Invoices Table
INSERT INTO Invoices (
    customer_id,
    transaction_date,
    total_price
)
VALUES
(
    (SELECT customer_id FROM Customers WHERE customer_name = :customer_name),
    :transaction_date,
    :total_price
);

-- Insert into Sales Table
INSERT INTO Sales
(
    invoice_id,
    product_id,
    quantity_sold
)
VALUES
(
    (SELECT invoice_id FROM Invoices WHERE customer_id = (SELECT customer_id FROM Customers WHERE customer_name = :customer_name)),
    (SELECT product_id FROM Products WHERE product_name = :product_name),
    :quantity_sold
);

-- Update Manufaturers Table
UPDATE Manufacturers 
SET manufacturer_name = :new_manufacturer_name
WHERE manufacterer_id = :manufacterer_id;

-- Update Products Table
UPDATE Products
SET product_name = :new_product_name, product_price = :new_product_price
WHERE product_id = :product_id;

-- Update Customers Table
UPDATE Customers
SET customer_name = :new_customer_name, customer_email = :new_customer_email, customer_phone = :new_customer_phone
WHERE customer_id = :customer_id;

-- Delete from Manufacturers Table
DELETE FROM Manufacturers WHERE manufacterer_id = :manufacterer_id;

-- Delete from Products Table
DELETE FROM Products WHERE product_id = :product_id;

-- Delete from Customers Table
DELETE FROM Customers WHERE customer_id = :customer_id;