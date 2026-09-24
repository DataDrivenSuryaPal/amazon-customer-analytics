/*
====================================================================================
============================================================================

Top products by reveue

============================================================================
====================================================================================
Purpose:
 - This report is about finding the top products by revenue per year.
Highlights:
 1. Gathering essential fields like Year, ProductID, Category, TotalAmount
 2. Aggregate Values
  - TotalRevenue
SQL functions used:
 - Aggregate function SUM()
 - Window rank function DENSE_RANK()
 - Clauses GROUP BY(), WHERE()
====================================================================================
*/
/*Top N products/categories by revenue, per year or per quarter*/
IF OBJECT_ID ('product_revenue_rank','v')
	IS NOT NULL
DROP VIEW product_revenue_rank;
GO
CREATE VIEW product_revenue_rank AS 
WITH product_revenue AS(
	SELECT
		t.Year,
		s.ProductID,
		p.ProductName,
		p.Category,
		SUM (TotalAmount) AS TotalRevenue
	FROM fact_sale AS s
	INNER JOIN dim_product AS p
		ON p.ProductID = s.ProductID
	INNER JOIN dim_time AS t 
		ON s.DateKey = t.DateKey
	GROUP BY t.Year,s.ProductID, p.ProductName, p.Category),
revenue_rank AS (
	SELECT
		Year,
		ProductID,
		ProductName,
		Category,
		TotalRevenue,
		DENSE_RANK() OVER 
			(PARTITION BY Year ORDER BY TotalRevenue DESC) AS RankRevenue
	FROM product_revenue)
SELECT
	Year,
	ProductName,
	Category,
	TotalRevenue,
	RankRevenue
FROM revenue_rank
WHERE RankRevenue <= 5
