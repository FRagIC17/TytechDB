USE TytechDB;
GO

CREATE TABLE Catalog.Categories
(
    category_id INT IDENTITY (1,1) PRIMARY KEY,
    category_name VARCHAR (100) NOT NULL
);

CREATE TABLE Catalog.Suppliers
(
    supplier_id INT IDENTITY (1,1) PRIMARY KEY,
    supplier_name VARCHAR (100) NOT NULL,
    supplier_address NVARCHAR (100),
    supplier_phone VARCHAR(20) NOT NULL,
    supplier_email NVARCHAR (75) NOT NULL
);

CREATE TABLE Catalog.Products
(
    product_id INT IDENTITY (1,1) PRIMARY KEY,
    product_name NVARCHAR (100) NOT NULL,
    product_description NVARCHAR(1000),
    product_price DECIMAL(10,2) NOT NULL,
    product_image_url NVARCHAR(max),
    product_published DATETIME,
    product_active BIT NOT NULL,
    category_id INT,
    supplier_id INT,
    FOREIGN KEY (category_id) REFERENCES Catalog.Categories (category_id),
    FOREIGN KEY (supplier_id) REFERENCES Catalog.Suppliers (supplier_id)
);

CREATE TABLE Catalog.SupplierProducts
(
    supplier_id INT NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY(supplier_id, product_id),
    FOREIGN KEY (supplier_id) REFERENCES Catalog.Suppliers (supplier_id),
    FOREIGN KEY (product_id) REFERENCES Catalog.Products (product_id)
);

CREATE TABLE Catalog.Inventory
(
    inventory_id INT IDENTITY (1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    inventory_quantity INT NOT NULL,
    inventory_product_name NVARCHAR (255) NOT NULL,
    inventory_last_updated DATETIME,
    FOREIGN KEY (product_id) REFERENCES Catalog.Products (product_id)
);

CREATE TABLE Customers.Customer
(
    customer_id INT IDENTITY (1,1) PRIMARY KEY,
    customer_firstname VARCHAR (50) NOT NULL,
    customer_lastname VARCHAR (75) NOT NULL,
    customer_email NVARCHAR (75) NOT NULL,
    customer_phone VARCHAR(20),
    customer_address NVARCHAR (100) NOT NULL,
    customer_postalcode VARCHAR(20) NOT NULL, 
    customer_city VARCHAR (50) NOT NULL,
    customer_country VARCHAR (50),
    customer_created_at DATETIME,
    customer_password NVARCHAR (50) NOT NULL
);

CREATE TABLE Sales.StatusEnnums
(
    status_id INT IDENTITY (1,1) PRIMARY KEY,
    shipment_status VARCHAR (10) NOT NULL,
    returns_status VARCHAR (9) NOT NULL,
    payment_status VARCHAR (10) NOT NULL,
    order_status NVARCHAR(20) NOT NULL
);

CREATE TABLE Sales.Orders
(
    order_id INT IDENTITY (1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    status_id INT NOT NULL,
    order_total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (status_id) REFERENCES Sales.StatusEnnums (status_id),
    FOREIGN KEY (customer_id) REFERENCES Customers.Customer (customer_id)
);

CREATE TABLE Sales.Order_lines
(
    ol_id INT IDENTITY (1,1) PRIMARY KEY,
    order_id INT,
    product_id INT,
    ol_quantity INT NOT NULL,
    ol_unit_price DECIMAL(10,2) NOT NULL,
    ol_discount FLOAT,
    FOREIGN KEY (order_id) REFERENCES Sales.Orders (order_id),
    FOREIGN KEY (product_id) REFERENCES Catalog.Products (product_id)
);

CREATE TABLE Sales.Payments
(
    payment_id INT IDENTITY (1,1) PRIMARY KEY,
    order_id INT,
    payment_date DATETIME NOT NULL,
    payment_method VARCHAR (20) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    status_id INT NOT NULL,
    FOREIGN KEY (status_id) REFERENCES Sales.StatusEnnums (status_id),
    FOREIGN KEY (order_id) REFERENCES Sales.Orders (order_id)
);

CREATE TABLE Sales.Shipments
(
    shipment_id INT IDENTITY (1,1) PRIMARY KEY,
    order_id INT,
    shipment_deliverer VARCHAR (50) NOT NULL,
    shipment_tracking_number VARCHAR(50) NOT NULL,
    shipment_date DATETIME NOT NULL,
    shipment_expected_delivery DATETIME NOT NULL,
    status_id INT NOT NULL,
    FOREIGN KEY (status_id) REFERENCES Sales.StatusEnnums (status_id),
    FOREIGN KEY (order_id) REFERENCES Sales.Orders (order_id)
);

CREATE TABLE Sales.ReturnOrders
(
    returnorders_id INT IDENTITY (1,1) PRIMARY KEY,
    order_id INT,
    product_id INT,
    returns_quantity INT NOT NULL,
    returns_reason VARCHAR (500) NOT NULL,
    status_id INT NOT NULL,
    returns_date DATETIME NOT NULL,
    FOREIGN KEY (status_id) REFERENCES Sales.StatusEnnums (status_id),
    FOREIGN KEY (order_id) REFERENCES Sales.Orders (order_id),
    FOREIGN KEY (product_id) REFERENCES Catalog.Products (product_id)
);