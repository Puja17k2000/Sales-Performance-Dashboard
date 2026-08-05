/* =====================================================
   Sales Performance Dashboard
   Advanced SQL Business Analysis

   Skills Demonstrated:
   - Aggregations
   - CASE Statements
   - CTEs
   - Window Functions
   - Ranking
   - Customer Analytics
   - Business KPIs
===================================================== */


-- 1. Overall Business KPIs

SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_Name) AS Total_Customers,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin
FROM Superstore;



-- 2. Sales Performance by Category

SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin
FROM Superstore
GROUP BY Category
ORDER BY Total_Sales DESC;



-- 3. Sub-Category Profit Analysis
-- Identify profitable and loss-making products

SELECT
    Sub_Category,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Profit,

    CASE
        WHEN SUM(Profit) > 0 THEN 'Profitable'
        ELSE 'Loss'
    END AS Performance_Status

FROM Superstore

GROUP BY Sub_Category
ORDER BY Profit DESC;



-- 4. Regional Sales and Profit Analysis

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM Superstore
GROUP BY Region
ORDER BY Total_Sales DESC;



-- 5. Monthly Sales Trend Analysis

SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Monthly_Sales,
    SUM(Profit) AS Monthly_Profit
FROM Superstore
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY Year, Month;



-- 6. Top 10 Customers by Revenue

SELECT TOP 10
    Customer_Name,
    SUM(Sales) AS Revenue,
    SUM(Profit) AS Profit
FROM Superstore
GROUP BY Customer_Name
ORDER BY Revenue DESC;



-- 7. Customer Segmentation Based on Spending

WITH Customer_Sales AS
(
    SELECT
        Customer_Name,
        SUM(Sales) AS Total_Sales
    FROM Superstore
    GROUP BY Customer_Name
)

SELECT
    Customer_Name,
    Total_Sales,

    CASE
        WHEN Total_Sales >= 5000 THEN 'High Value Customer'
        WHEN Total_Sales >= 2000 THEN 'Medium Value Customer'
        ELSE 'Low Value Customer'
    END AS Customer_Category

FROM Customer_Sales
ORDER BY Total_Sales DESC;



-- 8. Top Products by Sales

SELECT TOP 10
    Product_Name,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM Superstore
GROUP BY Product_Name
ORDER BY Total_Sales DESC;



-- 9. Loss Making Products

SELECT
    Product_Name,
    SUM(Sales) AS Sales,
    SUM(Profit) AS Loss

FROM Superstore

GROUP BY Product_Name

HAVING SUM(Profit) < 0

ORDER BY Loss;



-- 10. Discount Impact on Profit

SELECT
    Discount,
    AVG(Profit) AS Average_Profit,
    SUM(Sales) AS Total_Sales
FROM Superstore
GROUP BY Discount
ORDER BY Discount;



-- 11. Customer Ranking Using Window Function

SELECT

    Customer_Name,

    SUM(Sales) AS Total_Sales,

    RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS Customer_Rank

FROM Superstore

GROUP BY Customer_Name;



-- 12. Year Over Year Growth Analysis

WITH Yearly_Sales AS
(
    SELECT
        YEAR(Order_Date) AS Sales_Year,
        SUM(Sales) AS Revenue

    FROM Superstore

    GROUP BY YEAR(Order_Date)
)

SELECT

    Sales_Year,

    Revenue,

    LAG(Revenue) OVER(
        ORDER BY Sales_Year
    ) AS Previous_Year_Revenue,

    ROUND(
        ((Revenue -
        LAG(Revenue) OVER(ORDER BY Sales_Year))
        /
        LAG(Revenue) OVER(ORDER BY Sales_Year))*100,
        2
    ) AS Growth_Percentage

FROM Yearly_Sales;



-- 13. Shipping Mode Performance

SELECT
    Ship_Mode,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Sales) AS Sales,
    AVG(Profit) AS Average_Profit

FROM Superstore

GROUP BY Ship_Mode

ORDER BY Sales DESC;



-- 14. Most Profitable Region

SELECT TOP 1

    Region,

    SUM(Profit) AS Highest_Profit

FROM Superstore

GROUP BY Region

ORDER BY Highest_Profit DESC;



-- 15. Best Performing Category

SELECT TOP 1

    Category,

    SUM(Sales) AS Highest_Sales

FROM Superstore

GROUP BY Category

ORDER BY Highest_Sales DESC;
