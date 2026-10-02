-- =====================================================================
-- Project : Sales Performance Analysis | SQL & Power BI
-- Author  : Mohammed Tabrez Ali Khan
-- Dialect : SQL Server (T-SQL). Run the scripts in numerical order.
-- Data    : Synthetic (randomly generated) retail sales data, 2020-2024
-- =====================================================================
-- File 04: sales analysis queries (one block per business question)
-- Requires script 03 (vw_SalesDetail).
-- =====================================================================

-- ---------------------------------------------------------------------
-- KPI summary (matches the Power BI report totals)
-- ---------------------------------------------------------------------
SELECT COUNT(*)                          AS total_orders,
       SUM(UnitsSold)                    AS total_units,
       SUM(TotalSales)                   AS gross_sales,
       SUM(NetSales)                     AS net_sales,
       SUM(Profit)                       AS total_profit
FROM vw_SalesDetail;

-- ---------------------------------------------------------------------
-- Q1. Which products and product lines drive sales, profit and quantity?
-- ---------------------------------------------------------------------

-- Top 5 products by total sales
WITH product_sales AS (
    SELECT ProductName, SUM(TotalSales) AS total_sales,
           ROW_NUMBER() OVER (ORDER BY SUM(TotalSales) DESC, ProductName) AS rn
    FROM vw_SalesDetail
    GROUP BY ProductName
)
SELECT ProductName, total_sales FROM product_sales WHERE rn <= 5 ORDER BY rn;

-- Bottom 5 products by total sales
WITH product_sales AS (
    SELECT ProductName, SUM(TotalSales) AS total_sales,
           ROW_NUMBER() OVER (ORDER BY SUM(TotalSales) ASC, ProductName) AS rn
    FROM vw_SalesDetail
    GROUP BY ProductName
)
SELECT ProductName, total_sales FROM product_sales WHERE rn <= 5 ORDER BY rn;

-- Top 5 products by profit
WITH product_profit AS (
    SELECT ProductName, SUM(Profit) AS total_profit,
           ROW_NUMBER() OVER (ORDER BY SUM(Profit) DESC, ProductName) AS rn
    FROM vw_SalesDetail
    GROUP BY ProductName
)
SELECT ProductName, total_profit FROM product_profit WHERE rn <= 5 ORDER BY rn;

-- Top 5 products by quantity sold
WITH product_units AS (
    SELECT ProductName, SUM(UnitsSold) AS units_sold,
           ROW_NUMBER() OVER (ORDER BY SUM(UnitsSold) DESC, ProductName) AS rn
    FROM vw_SalesDetail
    GROUP BY ProductName
)
SELECT ProductName, units_sold FROM product_units WHERE rn <= 5 ORDER BY rn;

-- Bottom 5 products by quantity sold
WITH product_units AS (
    SELECT ProductName, SUM(UnitsSold) AS units_sold,
           ROW_NUMBER() OVER (ORDER BY SUM(UnitsSold) ASC, ProductName) AS rn
    FROM vw_SalesDetail
    GROUP BY ProductName
)
SELECT ProductName, units_sold FROM product_units WHERE rn <= 5 ORDER BY rn;

-- Sales and share of total by product line
SELECT ProductLine,
       SUM(TotalSales) AS gross_sales,
       ROUND(100.0 * SUM(TotalSales) / SUM(SUM(TotalSales)) OVER (), 1) AS pct_of_total_sales,
       SUM(UnitsSold)  AS units_sold
FROM vw_SalesDetail
GROUP BY ProductLine
ORDER BY gross_sales DESC;

-- ---------------------------------------------------------------------
-- Q2. How do sales change over time?
-- ---------------------------------------------------------------------

-- Net sales by year with year-on-year growth
-- 2024 is excluded because the data contains only one day of 2024 (1 January)
WITH yearly AS (
    SELECT OrderYear, SUM(NetSales) AS net_sales
    FROM vw_SalesDetail
    WHERE OrderYear <= 2023
    GROUP BY OrderYear
)
SELECT OrderYear,
       net_sales,
       LAG(net_sales) OVER (ORDER BY OrderYear) AS previous_year,
       ROUND(100.0 * (net_sales - LAG(net_sales) OVER (ORDER BY OrderYear))
             / NULLIF(LAG(net_sales) OVER (ORDER BY OrderYear), 0), 1) AS yoy_growth_pct
FROM yearly
ORDER BY OrderYear;

-- Monthly net sales with running total
WITH monthly AS (
    SELECT OrderYear, OrderMonth, SUM(NetSales) AS net_sales
    FROM vw_SalesDetail
    GROUP BY OrderYear, OrderMonth
)
SELECT OrderYear, OrderMonth, net_sales,
       SUM(net_sales) OVER (ORDER BY OrderYear, OrderMonth) AS running_total
FROM monthly
ORDER BY OrderYear, OrderMonth;

-- ---------------------------------------------------------------------
-- Q3. Which cities generate the most sales?
-- ---------------------------------------------------------------------
SELECT City,
       COUNT(*)      AS orders,
       SUM(NetSales) AS net_sales,
       RANK() OVER (ORDER BY SUM(NetSales) DESC) AS sales_rank
FROM vw_SalesDetail
GROUP BY City
ORDER BY sales_rank;

-- ---------------------------------------------------------------------
-- Q4. How do promotions and discounts affect sales?
-- ---------------------------------------------------------------------

-- Orders, net sales and average discount per order, by promotion
SELECT PromotionName,
       COUNT(*)                          AS orders,
       SUM(NetSales)                     AS net_sales,
       ROUND(AVG(DiscountValue), 0)      AS avg_discount_per_order,
       SUM(DiscountValue)                AS total_discount
FROM vw_SalesDetail
WHERE PromotionID IS NOT NULL
GROUP BY PromotionName
ORDER BY orders DESC;

-- Share of orders that used a promotion, and average order value with and without one
SELECT CASE WHEN PromotionID IS NULL THEN 'No promotion' ELSE 'With promotion' END AS order_type,
       COUNT(*)                                                         AS orders,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)               AS pct_of_orders,
       ROUND(AVG(NetSales), 0)                                          AS avg_net_sales_per_order
FROM vw_SalesDetail
GROUP BY CASE WHEN PromotionID IS NULL THEN 'No promotion' ELSE 'With promotion' END;

-- ---------------------------------------------------------------------
-- Q5. How does performance compare between two periods? (2022 vs 2023)
-- ---------------------------------------------------------------------
SELECT SUM(CASE WHEN OrderYear = 2022 THEN NetSales ELSE 0 END)  AS net_sales_2022,
       SUM(CASE WHEN OrderYear = 2023 THEN NetSales ELSE 0 END)  AS net_sales_2023,
       SUM(CASE WHEN OrderYear = 2022 THEN Profit ELSE 0 END)    AS profit_2022,
       SUM(CASE WHEN OrderYear = 2023 THEN Profit ELSE 0 END)    AS profit_2023,
       SUM(CASE WHEN OrderYear = 2022 THEN UnitsSold ELSE 0 END) AS units_2022,
       SUM(CASE WHEN OrderYear = 2023 THEN UnitsSold ELSE 0 END) AS units_2023
FROM vw_SalesDetail;
