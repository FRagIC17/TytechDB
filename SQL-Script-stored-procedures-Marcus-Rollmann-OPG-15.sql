
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
    @product_published DATETIME = NULL,
    @category_id INT = NULL,
    @supplier_id INT = NULL,
    @initial_quantity INT = 0
AS
BEGIN
    BEGIN TRANSACTION;
    
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
        1, -- Set as active by default
        @category_id,
        @supplier_id
    );
    
    DECLARE @new_product_id INT = SCOPE_IDENTITY();
    
    IF @initial_quantity > 0
    BEGIN
        INSERT INTO Catalog.Inventory (
            product_id,
            inventory_quantity,
            inventory_last_updated
        )
        VALUES (
            @new_product_id,
            @initial_quantity,
            GETDATE()
        );
    END;
    
    IF @supplier_id IS NOT NULL
    BEGIN
        INSERT INTO Catalog.SupplierProducts (supplier_id, product_id)
        VALUES (@supplier_id, @new_product_id);
    END;
    
    COMMIT TRANSACTION;
    

    SELECT @new_product_id AS new_product_id;
END;
GO


EXEC Catalog.pGetProductsByCategory @category_name = 'speakers';

EXEC pProductPriceRollBack 'Keyboard Also 589', 1;

EXEC Catalog.pDeleteProduct @product_id = 303;

EXEC Catalog.pInsertNewProduct 
    @product_name = 'Pik',
    @product_description = 'Kæmpe stor pik',
    @product_price = 29.99,
    @category_id = 1,
    @supplier_id = 1,
    @initial_quantity = 50;

SELECT * FROM Catalog.Products