-- =====================================================================
-- Project : Sales Performance Analysis | SQL & Power BI
-- Author  : Mohammed Tabrez Ali Khan
-- Dialect : SQL Server (T-SQL). Run the scripts in numerical order.
-- Data    : Synthetic (randomly generated) retail sales data, 2020-2024
-- =====================================================================
-- File 02: data validation and cleaning
-- =====================================================================

-- 1. Missing values in the order table (expected: 0 for every column)
SELECT SUM(CASE WHEN OrderDate  IS NULL THEN 1 ELSE 0 END) AS missing_date,
       SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS missing_customer,
       SUM(CASE WHEN ProductID  IS NULL THEN 1 ELSE 0 END) AS missing_product,
       SUM(CASE WHEN UnitsSold  IS NULL THEN 1 ELSE 0 END) AS missing_units
FROM Orders;

-- 2. Invalid quantities (expected: 0 rows)
SELECT * FROM Orders WHERE UnitsSold <= 0;

-- 3. Orders that point to a customer or product that does not exist (expected: 0 rows)
SELECT o.OrderID, o.CustomerID, o.ProductID
FROM Orders o
LEFT JOIN Customers c ON c.CustomerID = o.CustomerID
LEFT JOIN Products  p ON p.ProductID  = o.ProductID
WHERE c.CustomerID IS NULL OR p.ProductID IS NULL;

-- 4. Repeated orders (same date, customer, product, promotion and units)
--    A few rows repeat. In this dataset they are treated as separate valid orders
--    (a customer can buy the same item twice on one day), so they are kept.
SELECT OrderDate, CustomerID, ProductID, PromotionID, UnitsSold, COUNT(*) AS copies
FROM Orders
GROUP BY OrderDate, CustomerID, ProductID, PromotionID, UnitsSold
HAVING COUNT(*) > 1;

-- 5. Extra spaces in customer text fields (the source data has trailing spaces)
SELECT COUNT(*) AS rows_with_extra_spaces
FROM Customers
WHERE City <> LTRIM(RTRIM(City))
   OR State <> LTRIM(RTRIM(State))
   OR CustomerName <> LTRIM(RTRIM(CustomerName));

-- ---------------------------------------------------------------------
-- Cleaning
-- ---------------------------------------------------------------------

-- Remove extra spaces from customer text fields
UPDATE Customers
SET CustomerName = LTRIM(RTRIM(CustomerName)),
    City         = LTRIM(RTRIM(City)),
    State        = LTRIM(RTRIM(State));

-- PromotionID = '0' means no promotion: store it as NULL
UPDATE Orders SET PromotionID = NULL WHERE PromotionID = '0';

-- Orders that use a promotion code that is not in the Promotions table (expected: 0 rows)
SELECT o.OrderID, o.PromotionID
FROM Orders o
LEFT JOIN Promotions pr ON pr.PromotionID = o.PromotionID
WHERE o.PromotionID IS NOT NULL AND pr.PromotionID IS NULL;

-- Re-check: distinct cities after cleaning (expected: 16)
SELECT COUNT(DISTINCT City) AS distinct_cities FROM Customers;
