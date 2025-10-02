USE TytechDB
GO


--view til at se vigtige informationer om produkterne
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
INNER JOIN Catalog.Categories c ON p.category_id = c.category_id
INNER JOIN Catalog.Suppliers s ON p.supplier_id = s.supplier_id
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
GROUP BY 
    c.customer_id,
    c.customer_firstname,
    c.customer_lastname,
    c.customer_email,
    c.customer_city,
    c.customer_country;

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