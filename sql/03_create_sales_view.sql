-- =====================================================================
-- Project : Sales Performance Analysis | SQL & Power BI
-- Author  : Mohammed Tabrez Ali Khan
-- Dialect : SQL Server (T-SQL). Run the scripts in numerical order.
-- Data    : Synthetic (randomly generated) retail sales data, 2020-2024
-- =====================================================================
-- File 03: build the analysis view
-- Joins the four tables and calculates the derived fields:
-- price per unit, total sales, discount %, discount value, net sales, profit.
-- Business rules (same as the Power BI report):
--   Total Sales (gross) = Units Sold x Price per Unit
--   Discount %          = set by promotion (Buy 1 Get 1 Free is treated as 0%)
--   Net Sales           = Total Sales - Discount Value
--   Profit              = 10% of Net Sales
-- =====================================================================

DROP VIEW IF EXISTS vw_SalesDetail;
GO

CREATE VIEW vw_SalesDetail AS
WITH base AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        YEAR(o.OrderDate)   AS OrderYear,
        MONTH(o.OrderDate)  AS OrderMonth,
        o.CustomerID,
        c.CustomerName,
        c.City,
        c.State,
        o.ProductID,
        p.ProductName,
        p.ProductLine,
        o.PromotionID,
        pr.PromotionName,
        o.UnitsSold,
        p.PriceINR AS PricePerUnit,
        o.UnitsSold * p.PriceINR AS TotalSales,
        CASE o.PromotionID
            WHEN 'PR001' THEN 20     -- Summer Sale        20% off
            WHEN 'PR002' THEN 10     -- Festive Diwali     10% off
            WHEN 'PR003' THEN 0      -- New Year Special   Buy 1 Get 1 Free
            WHEN 'PR004' THEN 50     -- Weekend Flash Sale 50% off
            WHEN 'PR005' THEN 70     -- Clearance Sale     70% off
            ELSE 0
        END AS DiscountPercentage
    FROM Orders o
    JOIN Customers c       ON c.CustomerID  = o.CustomerID
    JOIN Products  p       ON p.ProductID   = o.ProductID
    LEFT JOIN Promotions pr ON pr.PromotionID = o.PromotionID
)
SELECT
    OrderID, OrderDate, OrderYear, OrderMonth,
    CustomerID, CustomerName, City, State,
    ProductID, ProductName, ProductLine,
    PromotionID, PromotionName,
    UnitsSold, PricePerUnit, TotalSales, DiscountPercentage,
    CAST(TotalSales * DiscountPercentage / 100.0 AS DECIMAL(18,2))                       AS DiscountValue,
    CAST(TotalSales - TotalSales * DiscountPercentage / 100.0 AS DECIMAL(18,2))          AS NetSales,
    CAST((TotalSales - TotalSales * DiscountPercentage / 100.0) * 0.10 AS DECIMAL(18,2)) AS Profit
FROM base;
GO

-- Check: total rows should equal the order count (3510)
SELECT COUNT(*) AS rows_in_view FROM vw_SalesDetail;
