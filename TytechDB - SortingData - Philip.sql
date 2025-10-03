USE TytechDB
GO

SELECT * FROM Catalog.Products ORDER BY Product_name;
SELECT * FROM Catalog.Products ORDER BY product_price desc; --desc er dyreste først, asc er billigste først

SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM Catalog.Products p
INNER JOIN Catalog.Categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

SELECT 
    payment_method,
    COUNT(payment_id) AS payment_count
FROM Sales.Payments
GROUP BY payment_method;

SELECT * FROM Catalog.Inventory WHERE inventory_quantity > 200;


SELECT 
COUNT (order_id) as total_orders,
MAX (customer_id) as total_customers
FROM Sales.Orders;

SELECT
s.supplier_name,
p.product_name
FROM catalog.supplierproducts sp
INNER JOIN Catalog.Suppliers s ON sp.supplier_id = s.supplier_id
INNER JOIN Catalog.Products p ON sp.product_id = p.product_id;