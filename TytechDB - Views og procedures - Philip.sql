USE TytechDB
GO




--Create views

--view til at se vigtige informationer om produkter
CREATE VIEW Catalog.ProductCatalog AS
SELECT 
    p.product_id,
    p.product_name,
    p.product_description,
    p.product_price,
    p.product_image_url,
    p.product_published,
    p.product_active,
    c.category_name,
    s.supplier_name,
    i.inventory_quantity
FROM Catalog.Products p
LEFT JOIN Catalog.Categories c ON p.category_id = c.category_id
LEFT JOIN Catalog.Suppliers s ON p.supplier_id = s.supplier_id
LEFT JOIN Catalog.Inventory i ON p.product_id = i.product_id

SELECT * FROM Catalog.ProductCatalog


--view til kundens ordrer informationer
CREATE VIEW Sales.CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.customer_firstname + ' ' + c.customer_lastname AS customer_name,
    c.customer_email,
    c.customer_city,
    c.customer_country,
    COUNT(o.order_id) AS total_orders,
    SUM(ol.ol_quantity * p.product_price) AS total_spent,
    MAX(o.order_date) AS last_order_date
FROM Customers.Customer c
LEFT JOIN Sales.Orders o ON c.customer_id = o.customer_id
LEFT JOIN Sales.Order_lines ol ON o.order_id = ol.order_id
LEFT JOIN Catalog.Products p ON ol.product_id = p.product_id


SELECT * FROM Sales.CustomerOrderSummary


--view til information om levering
CREATE VIEW Sales.vDeliveryInformation AS
SELECT
    o.order_id,
    CONCAT(c.customer_firstname, ' ', c.customer_lastname) as full_name,
    s.supplier_name,
    sh.shipment_deliverer,
    c.customer_address,
    o.order_date,
    sh.shipment_expected_delivery,
    se.order_status
    FROM Sales.Orders o
INNER JOIN Customers.Customer c ON o.customer_id = c.customer_id
INNER JOIN Sales.StatusEnnums se ON o.status_id = se.status_id
INNER JOIN Sales.Shipments sh ON o.order_id = sh.order_id
INNER JOIN Sales.Order_lines ol ON o.order_id = ol.order_id
INNER JOIN Catalog.Products p ON ol.product_id = p.product_id
INNER JOIN Catalog.Suppliers s ON p.supplier_id = s.supplier_id;

SELECT * FROM Sales.vDeliveryInformation




--Create Procedure

-- subquery til at finde specifikt en category
CREATE PROCEDURE Catalog.pGetProductsByCategory
    @category_name VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        product_id,
        product_name,
        product_price,
        product_description
    FROM Catalog.Products
    WHERE category_id IN (

        SELECT category_id 
        FROM Catalog.Categories 
        WHERE category_name = @category_name
    )
    AND product_active = 1
    ORDER BY product_name;
END;
GO


-- vores roll back stored procedure
CREATE PROCEDURE pProductPriceRollBack
    @product_name VARCHAR(100),
    @product_price DECIMAL(10,2)
AS
BEGIN
    BEGIN TRANSACTION;

    INSERT INTO Catalog.Products (product_name, product_price, product_active)
    VALUES (@product_name, @product_price, 1);

    IF @product_price <= 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Product price must be greater than 0. Changes cancelled.';
        RETURN;
    END

    COMMIT TRANSACTION;
    PRINT 'Product added successfully!';
END;
GO


--for at slette et produkt
CREATE PROCEDURE Catalog.pDeleteProduct
    @product_id INT
AS
BEGIN
    BEGIN TRANSACTION;
    
    DELETE FROM Catalog.SupplierProducts WHERE product_id = @product_id;
    DELETE FROM Catalog.Inventory WHERE product_id = @product_id;
    
    DELETE FROM Catalog.Products WHERE product_id = @product_id;
    
    COMMIT TRANSACTION;
    PRINT 'Product deleted!';
END;
GO


--for at oprette et nyt produkt
CREATE PROCEDURE Catalog.pInsertNewProduct
    @product_name NVARCHAR(100),
    @product_description NVARCHAR(1000) = NULL,
    @product_price DECIMAL(10,2),
    @product_image_url NVARCHAR(MAX) = NULL,
    @product_active BIT,
    @product_published DATETIME = NULL,
    @category_id INT,
    @supplier_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        INSERT INTO Catalog.Products (
            product_name,
            product_description,
            product_price,
            product_image_url,
            product_published,
            product_active,
            category_id,
            supplier_id
        )
        VALUES (
            @product_name,
            @product_description,
            @product_price,
            @product_image_url,
            ISNULL(@product_published, GETDATE()),
            @product_active,
            @category_id,
            @supplier_id
        );

        DECLARE @new_product_id INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT @new_product_id AS new_product_id;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

EXEC Catalog.pGetProductsByCategory @category_name = 'speakers';

EXEC pProductPriceRollBack 'Keyboard Also 589', 1;

EXEC Catalog.pDeleteProduct @product_id = 303;

EXEC Catalog.pInsertNewProduct 
    @product_name = 'produktnavn',
    @product_description = 'dette er en beskrivelse',
    @product_price = 29.99,
    @category_id = 1,
    @supplier_id = 1,
    @initial_quantity = 50;

SELECT * FROM Catalog.Products

--opgave 16
--USE TytechDB
--GO

--SELECT * FROM Catalog.Products ORDER BY Product_name;
--SELECT * FROM Catalog.Products ORDER BY product_price desc; --desc er dyreste først, asc er billigste først

--SELECT 
--    c.category_name,
--    COUNT(p.product_id) AS product_count
--FROM Catalog.Products p
--INNER JOIN Catalog.Categories c ON p.category_id = c.category_id
--GROUP BY c.category_name;

--SELECT 
--    payment_method,
--    COUNT(payment_id) AS payment_count
--FROM Sales.Payments
--GROUP BY payment_method;

--SELECT * FROM Catalog.Inventory WHERE inventory_quantity > 200;


--SELECT 
--COUNT (order_id) as total_orders,
--MAX (customer_id) as total_customers
--FROM Sales.Orders;

--SELECT
--s.supplier_name,
--p.product_name
--FROM catalog.supplierproducts sp
--INNER JOIN Catalog.Suppliers s ON sp.supplier_id = s.supplier_id
--INNER JOIN Catalog.Products p ON sp.product_id = p.product_id;


--opgave 18
--USE TytechDB
--GO

--DBCC CHECKTABLE ('Catalog.Products')
--DBCC CHECKDB ('TytechDB')



