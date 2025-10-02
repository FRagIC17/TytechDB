-- Det der står under er et delete script der reseter id også.
USE TytechDB
GO

DELETE FROM Catalog.Categories

DBCC CHECKIDENT ('Catalog.Categories', RESEED, 0);

DELETE FROM Catalog.Products

DBCC CHECKIDENT ('Catalog.Products', RESEED, 0);

DELETE FROM Catalog.Suppliers

DBCC CHECKIDENT ('Catalog.Suppliers', RESEED, 0);

DELETE FROM Catalog.SupplierProducts 

DELETE FROM Sales.StatusEnnums

DBCC CHECKIDENT ('Sales.StatusEnnums', RESEED, 0);

ALTER TABLE Sales.StatusEnnums
ALTER COLUMN order_status VARCHAR(13) NOT NULL;

ALTER TABLE Sales.StatusEnnums
ALTER COLUMN shipment_status VARCHAR(13) NOT NULL;

ALTER TABLE Sales.StatusEnnums
ALTER COLUMN returns_status VARCHAR(13) NOT NULL;

ALTER TABLE Sales.StatusEnnums
ALTER COLUMN payment_status VARCHAR(13) NOT NULL;